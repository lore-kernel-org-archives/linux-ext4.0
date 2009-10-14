From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 2/2] ext4: update donor file's ctime/mtime
Date: Wed, 14 Oct 2009 10:49:34 +0900
Message-ID: <4AD52E2E.80404@sx.jp.nec.com>
References: <4ACD9D04.40503@sx.jp.nec.com> <EE52B431-D993-47A3-B914-5FE2ACE953B8@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47865 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZJNBzt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 21:55:49 -0400
In-Reply-To: <EE52B431-D993-47A3-B914-5FE2ACE953B8@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/10/10 2:20, Andreas Dilger wrote::
> 
> On 8-Oct-09, at 02:04, Kazuya Mio wrote:
> 
>> EXT4_IOC_MOVE_EXT changes donor file data, but doesn't update 
>> ctime/mtime.
>> This patch fixes this problem.
> 
> I would argue that just migrating the file data shouldn't update the 
> ctime/mtime.
> Those are used to determine if the file has changed in some way, usually 
> for the
> purpose of backup.  Migrating the data does not change anything from the 
> user-space
> POV and shouldn't force a new backup of the file.

EXT4_IOC_MOVE_EXT always changes the original actual contents of donor file
if orig file and donor file aren't the same. It may be that some of
user-space implementations hide such a changing. For example, e4defrag
unlinks the donor file, and removes it by decreasing reference count after
calling EXT4_IOC_MOVE_EXT. But from the ioctl point of view,
EXT4_IOC_MOVE_EXT doesn't know whether donor file will be removed or not,
so I think we should update ctime/mtime.

Am I missing something?

Regards,
Kazuya Mio
