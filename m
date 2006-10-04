From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext2/ext3 errors behaviour fixes
Date: Wed, 4 Oct 2006 09:07:47 -0600
Message-ID: <20061004150747.GC22010@schatzie.adilger.int>
References: <452367A8.3010405@sw.ru> <20061004150236.GB22010@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46485 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1161166AbWJDPHs
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Oct 2006 11:07:48 -0400
To: Vasily Averin <vvs@sw.ru>, Theodore Tso <tytso@mit.edu>,
	Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@osdl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, devel@openvz.org, cmm@us.ibm.com,
	Eric Sandeen <sandeen@sandeen.net>,
	Kirill Korotaev <dev@openvz.org>
Content-Disposition: inline
In-Reply-To: <20061004150236.GB22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 04, 2006  09:02 -0600, Andreas Dilger wrote:
> On Oct 04, 2006  11:50 +0400, Vasily Averin wrote:
> > However EXT3_ERRORS_CONTINUE is not read from the superblock, and thus
> > ERRORS_CONT is not saved on the sbi->s_mount_opt. It leads to the incorrect
> > handle of errors on ext3.
> > 
> > The following patches fix this.
> 
> {patch is missing}

Sorry, nm.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

