From: Andreas Dilger <adilger@sun.com>
Subject: Re: [Ocfs2-devel] Add FIEMAP_EXTENT_SHARED flag
Date: Fri, 18 Dec 2009 14:24:09 -0700
Message-ID: <2D18A332-D252-455A-B0DC-BFC1E2E4C8A2@sun.com>
References: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
 <20091218051040.GB20149@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com,
	ext4 development <linux-ext4@vger.kernel.org>
To: Joel Becker <Joel.Becker@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62048 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712AbZLRVYT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Dec 2009 16:24:19 -0500
In-reply-to: <20091218051040.GB20149@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-12-17, at 22:10, Joel Becker wrote:
> On Thu, Dec 03, 2009 at 12:46:50PM -0800, Sunil Mushran wrote:
>> Please could you Ack this patch. This adds a new FIEMAP flag to  
>> denote
>> shared extents which we are using to identify such exents in  
>> reflinked
>> files.
>
> 	These patches are now in ocfs2.git.  If anyone has any concerns,
> let me know.


Hi Joel,
are there any plans to submit an e2fsprogs patch to print out the  
"shared" extent flag from "filefrag"?

At first glance it would also seem to make sense to set this flag for  
ext2/3/4 xattrs that are sharing an external extent block.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

