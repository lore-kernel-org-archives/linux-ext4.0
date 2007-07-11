From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Initial results of FLEX_BG feature.
Date: Wed, 11 Jul 2007 00:39:46 -0500
Message-ID: <46946D22.3060409@redhat.com>
References: <20070710112307.34c2ba5c@rx8>	<20070711041213.GH6417@schatzie.adilger.int> <20070711003004.531c9307@naruto>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXGKFkC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 01:40:02 -0400
In-Reply-To: <20070711003004.531c9307@naruto>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jose R. Santos wrote:
> On Tue, 10 Jul 2007 22:12:14 -0600
> Andreas Dilger <adilger@clusterfs.com> wrote:

...

>  
>> You might also want to test out placement of the journal in the middle
>> of the filesystem, the U. Wisconsin folks tested this in one of their
>> papers and showed some noticable improvements.  That isn't exactly
>> related, but it is a relatively simple tweak to mke2fs/tune2fs to give
>> it an allocation goal of group_desc[s_groups_count / 2].bg_inode_table
>> (to put it past inode table in middle group).
> 
> Make sense.  Do you have a link to the paper?

filesystem shrinking would need to be fixed to handle this too, right...

-Eric
