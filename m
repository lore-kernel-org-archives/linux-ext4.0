From: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: Shred mount option for ext4?
Date: Tue, 31 Oct 2006 14:02:00 +0100
Message-ID: <2006-10-31-14-02-00+trackit+sam@rfc1149.net>
References: <87hcxkpyas.fsf@willow.rfc1149.net> <20061031123222.GB17972@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from anyanka.rfc1149.net ([81.56.47.149]:54258 "EHLO
	mail2.rfc1149.net") by vger.kernel.org with ESMTP id S1423183AbWJaNCC
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Oct 2006 08:02:02 -0500
To: Erik Mouw <erik@harddisk-recovery.com>
Content-Disposition: inline
In-Reply-To: <20061031123222.GB17972@harddisk-recovery.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 31/10, Erik Mouw wrote:

| Why don't you just make a libc wrapper for the unlink(2) system call?
| (A modified libc.so should do as well). That way it will work for all
| of your applications on all filesystems.

Because this won't take care of the journal, which may contain an extra
copy of the previously written data. Also in transactional filesystems,
overwriting data doesn't guarantee that the data is written in the same
place: it will typically be written at another place and then the
metadata will be updated afterwards. You have no control about that at
user level, since you can't hook into the block freeing routine.

Thanks for the reference btw :)
