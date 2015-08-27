From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: errors following ext3 to ext4 conversion
Date: Thu, 27 Aug 2015 16:34:05 -0500
Message-ID: <55DF824D.7040302@redhat.com>
References: <55DE5F79.4010004@yale.edu> <20150827033949.GA12151@thunk.org> <55DE8771.9050109@redhat.com> <20150827041536.GH10037@birch.djwong.org> <20150827185845.GB3357@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Chris Hunter <chris.hunter@yale.edu>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbbH0VeH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2015 17:34:07 -0400
In-Reply-To: <20150827185845.GB3357@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/27/15 1:58 PM, Theodore Ts'o wrote:
> I suspect that would fill Eric's heart with horror, but the ability to
> migrate the root file system from ext2 to ext3 while it was mounted
> (i.e., just run "tune2fs -O has_journal /dev/rootfs" and reboot) was
> something Stephen Tweedie added, so at least at one point Red Hat was
> more adventurous about what it would support in terms of file system
> upgrades without using mkfs.  :-)
> 
>     	     		       	       - Ted

Oh, it doesn't fill me with *that* much horror.  ;)

TBH, my big problem with the ext3->ext4 "migration" is that you wind
up with a mongrel filesystem which mkfs.ext4 would never create,
populated with files of varying runtime limitations and capabilities,
depending on whether they were created before or after the "migration."

Adding a journal and rebooting at least gets you to a pretty standard,
predictable, and tested result.  ;)

-Eric
