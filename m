From: Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 23:28:34 +0200
Message-ID: <1c30a215-b67a-1e42-2e7d-078882125094@darmarit.de>
References: <20180719181556.GA21435@thunk.org>
 <20180719190400.GB4800@magnolia>
 <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
 <20180720131206.GM30706@thunk.org>
 <d064f468ab9fc60a02242331e0dddc185d6556ba.camel@darmarit.de>
 <20180720145235.GA27862@thunk.org>
 <cd31ba58ac24851698e06628ceebce4648345ff6.camel@darmarit.de>
 <20180720164421.GG4800@magnolia>
 <93aa59853a491a5ba3d5c3bcc0c991a1b815a67d.camel@darmarit.de>
 <20180720171020.GI4800@magnolia> <20180720204343.GC27862@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720204343.GC27862@thunk.org>
Content-Language: de-DE
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 20.07.2018 22:43, Theodore Y. Ts'o wrote:
> So if Documentation/sphinx/requirements.txt is the only thing which is
> guaranteed to work, that's fine.  But it might be good to document
> that somewhere.

Hm, I read it again and I guess this is more ore less what the documentation
will say, see 'Sphinx Install' section. [1]

- distros are fragile
- Documentation/sphinx/requirements.txt is the reference environment

.. even if this needs a virtualenv on specific distros. But what is with
the offline build systems Christoph mentioned? I can't see a solution on
the sometimes contradictory requirements on a *reference env* and the package
reposetorie of a distro.

[1] https://www.kernel.org/doc/html/latest/doc-guide/sphinx.html?#sphinx-install

--Markus--
