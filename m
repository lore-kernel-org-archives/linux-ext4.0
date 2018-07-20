From: Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 18:58:57 +0200
Message-ID: <93aa59853a491a5ba3d5c3bcc0c991a1b815a67d.camel@darmarit.de>
References: <20180719181556.GA21435@thunk.org>
         <20180719190400.GB4800@magnolia>
         <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
         <20180720131206.GM30706@thunk.org>
         <d064f468ab9fc60a02242331e0dddc185d6556ba.camel@darmarit.de>
         <20180720145235.GA27862@thunk.org>
         <cd31ba58ac24851698e06628ceebce4648345ff6.camel@darmarit.de>
         <20180720164421.GG4800@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720164421.GG4800@magnolia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Freitag, den 20.07.2018, 09:44 -0700 schrieb Darrick J. Wong:
> and now I'm just confused since 16.04 has the same version of docutils
> and an older sphinx and runs fine; but 18.04 has newer docutils and
> newer sphinx and runs fine.

Same here .. I'am completely confused by distros etc. .. I will never be able to
control that. Thats why I recommend the virtualenv workflow (as I wrote Christoph):

$ sudo apt install python3-virtualenv

To setup up a environment for building htmldocs:

$ python3 -m virtualenv py3env
$ ./py3env/bin/pip install -r ./Documentation/sphinx/requirements.txt

To build htmldocs with:

 $ SPHINXBUILD=./py3env/bin/sphinx-build make htmldocs

If the env is no longer needed:

 $ rm -r py3env

Am Freitag, den 20.07.2018, 09:44 -0700 schrieb Darrick J. Wong:
> Yes.  This makes writing broadly portable markup difficult -- originally
> I did not take the '=' all the way to the right edge of the table
> because I saw that last example in the above document and assumed that
> it wasn't necessary to extend the '=' all the way to the right edge.
> Neither Ubuntu system choked on it, so is this a bug in upstream?  Some
> strange patch added by the distro?  Something that ended up in the
> python wheel?  Or a bug in the spec?

I guess in the version history of docutils ;) .. use workflow above to escape
from distro chaos. Even missing '=' will be OK.

-- Markus --
