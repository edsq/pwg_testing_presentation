# Testing with Python
## WSU: Python Working Group - 8 March 2023



# Deploying on [GitHub][] and [GitLab][]

## Mercurial

I prefer to use [mercurial][], so to push to [GitHub][] and [GitLab][], I use
[hg-git][].  There are a couple of things to do:

0. Make sure you have [mercurial][] installed with the [evolve][] and [hg-git][]
   extensions.  I use [pipx][] for this at the system level, but you could include this
   in your project:
   
   ```bash
   pipx install mercurial
   pipx inject mercurial evolve hg-git
   ```
   
1. Add a bookmark with the default branch (now called `main`):

    ```bash
    hg bookmark -r default main
    ```

2. Create your projects on [GitLab][] and [GitHub][] and add tokens etc. so you can push
   and pull.  Optionally, setup repository
   mirroring so you only have to push to one.
   
   * Make sure you create a blank project!  No Readme file etc.

3. Add these to `.hg/hgrc`:

    ```
    [paths]
    gitlab = git+ssh://git@gitlab.com:wsu-courses/pwg/2023-testing-with-python.git
    github = git+ssh://git@github.com/schacon/some-repo.git
    ```

4. Push!

    ```bash
    hg push gitlab
    hg push github
    ```


and 


[mercurial]: https://www.mercurial-scm.org/
[GitLab]: https://gitlab.com/
[GitHub]: https://github.com/
[hg-git]: https://hg-git.github.io/
[evolve]: https://www.mercurial-scm.org/doc/evolution/
[pipx]: https://pypa.github.io/pipx/
