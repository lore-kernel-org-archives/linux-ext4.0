From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4 08/11] vfs: Add new file and directory create permission flags
Date: Mon, 03 Jan 2011 19:50:57 +0530
Message-ID: <87hbdqdq5y.fsf@linux.vnet.ibm.com>
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285332494-12756-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100924115423.530813c3@tlielax.poochiereds.net> <201009271514.00279.agruen@suse.de> <20110102232101.GB11955@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton@redhat.com>, sfrench@us.ibm.com,
	ffilz@us.ibm.com, adilger@sun.com, sandeen@redhat.com,
	bfields@citi.umich.edu, linux-fsdevel@vger.kernel.org,
	nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33696 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab1ACOVL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jan 2011 09:21:11 -0500
In-Reply-To: <20110102232101.GB11955@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2 Jan 2011 18:21:01 -0500, "Ted Ts'o" <tytso@mit.edu> wrote:
> I was going through some old patches in the ext4 patchwork list, and
> came across this.  It looks like this patch has never been applied to
> mainline.  If it's a "clear improvement", any reason not to submit it?

The patch is needed only with richacl patches, that add an extra argument to
may_create.

-aneesh
