From: Markus Heiser <markus.heiser@darmarit.de>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 18:28:09 +0200
Message-ID: <1cc801608a1e71b54fe97aae6f5ad2a0024e8e5d.camel@darmarit.de>
References: <20180719181556.GA21435@thunk.org>
         <20180719190400.GB4800@magnolia>
         <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
         <20180720150402.GA32320@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720150402.GA32320@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Freitag, den 20.07.2018, 08:04 -0700 schrieb Christoph Hellwig:
> On Fri, Jul 20, 2018 at 09:30:33AM +0200, Markus Heiser wrote:
> > We have this discussion over and over again an I believe we will have it again
> > and again, as long as we do not change our POV .. building viewing formats is
> > an application not a part of the Kernel.
> 
> Sorry, but this is complete and utter bullshit.

Maybe .. I'am not a Kernel developer .. I only try to help with the doc tool-
chain. But if I don't want to install anything from the web, the plain text
is not as bad.

> 
> If that was the case we could skip all that RST stuff and just stick
> to text files.  If we want fancy docs it better behave like the rest
> of the kernel and just works.  python virtual environments are just
> not going to cut it as they lead to a long-term maintainance nightmare.

Really a nightmare? This is what I do on my ubuntu/debian box ... I do
prefer py3 so I installed *virtualenv-py3* once from distro's package
manager:

$ sudo apt install python3-virtualenv

To setup up a environment for building htmldocs:

$ python3 -m virtualenv py3env
$ ./py3env/bin/pip install -r ./Documentation/sphinx/requirements.txt

now I have all installed in the in the py3env folder. To build htmldocs
with:

 $ SPHINXBUILD=./py3env/bin/sphinx-build make htmldocs

If the env is no longer needed:

 $ rm -r py3env

 -- Markus --


> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
