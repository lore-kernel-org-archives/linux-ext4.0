From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Sphinx version dependencies?
Date: Fri, 20 Jul 2018 08:04:02 -0700
Message-ID: <20180720150402.GA32320@infradead.org>
References: <20180719181556.GA21435@thunk.org>
 <20180719190400.GB4800@magnolia>
 <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Markus Heiser <markus.heiser@darmarit.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44d73cd9926f58976a1269ff3cd3afb845ec84fa.camel@darmarit.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2018 at 09:30:33AM +0200, Markus Heiser wrote:
> We have this discussion over and over again an I believe we will have it again
> and again, as long as we do not change our POV .. building viewing formats is
> an application not a part of the Kernel.

Sorry, but this is complete and utter bullshit.

If that was the case we could skip all that RST stuff and just stick
to text files.  If we want fancy docs it better behave like the rest
of the kernel and just works.  python virtual environments are just
not going to cut it as they lead to a long-term maintainance nightmare.
