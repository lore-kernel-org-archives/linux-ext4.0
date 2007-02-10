From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs coverity patch <cid-1.diff>
Date: Sat, 10 Feb 2007 08:55:01 -0500
Message-ID: <20070210135501.GA25607@thunk.org>
References: <200702100208.l1A28GC2005813@igsi.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	wartens2@llnl.gov
To: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38111 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbXBJNzI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Feb 2007 08:55:08 -0500
Content-Disposition: inline
In-Reply-To: <200702100208.l1A28GC2005813@igsi.llnl.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Feb 09, 2007 at 06:08:16PM -0800, Brian D. Behlendorf wrote:
> Lawrence Livermore National Labs recently ran the source code
> analysis tool Coverity over the e2fsprogs-1.39 source to see 
> if it would identify any significant bugs.  The analysis
> turned up 38 mostly minor issues which are enumerated here
> with patches.  We went through and resolved these issues
> but would love to see these mostly minor changes reviewed
> and commited upstream.

Hi Brian, please see the SUBMITTING-PATCHES file in the e2fsprogs
repository.  

May I assume that you are willing to certify to the Developer's
Certification of Origin 1.1 statement so I can add a:

Signed-off-by: Brian Behlendorf <behlendorf1@llnl.gov>

to each of these patches before I check them into the e2fsprogs source
control repository?  

In the future, please add the Signed-off-by: line when submitting
patches assuming that you are willing to certify to the DCO 1.1.

Thanks, regards,

						- Ted


(The SUBMITTING-PATCHES file has been included below for your
convenience.)

Like the Linux kernel, submitted e2fsprogs patches now require the
following "sign-off" procedure:

The sign-off is a simple line at the end of the explanation for the
patch, which certifies that you wrote it or otherwise have the right to
pass it on as a open-source patch.  The rules are pretty simple: if you
can certify the below:

        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

	(d) I understand and agree that this project and the contribution
	    are public and that a record of the contribution (including all
	    personal information I submit with it, including my sign-off) is
	    maintained indefinitely and may be redistributed consistent with
	    this project or the open source license(s) involved.

then you just add a line saying

	Signed-off-by: Random J Developer <random@developer.example.org>
