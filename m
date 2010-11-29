From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Bug#605009: serious performance regression with ext4
Date: Mon, 29 Nov 2010 13:50:11 -0700
Message-ID: <D80DBAF8-E6C0-407D-AABF-45AFDB73C404@dilger.ca>
References: <20101126093257.23480.86900.reportbug@pluto.milchstrasse.xx> <20101129072930.GA7213@burratino> <20101129144436.GT2767@thunk.org> <201011291618.25084.bernd.schubert@fastmail.fm>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>, Jonathan Nieder <jrnieder@gmail.com>,
	linux-ext4@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:21733 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0K2UuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 15:50:12 -0500
In-Reply-To: <201011291618.25084.bernd.schubert@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-29, at 08:18, Bernd Schubert wrote:
> Wouldn't it make sense to modify ext4 or even the vfs to do that on
> close() itself? Most applications expect the file to be on disk after
> a close anyway and I also don't see a good reason why one should delay
> a disk write-back after close any longer (well, there are exeption if
> the application is broken, for example such as ha-logd used by pacemaker,
> which did for each line of logs an open, seek, write, flush, close
> sequence..., but at least we have fixed that in -hg now).

This would be terrible for applications like tar that create many hundreds or thousands of files.  Also, doesn't NFS also internally open/close the file for every write?

There would now be an implicit fsync and disk cache flush for every created file.  It would be impossible to create or extract more than about 100 files/second on an HDD due to seek limitations, even if the files are tiny and do not fill the memory.

I can imagine that it might make sense to _start_ writeback sooner than what the VM currently does, if an application is not repeatedly opening, writing, and closing the same file, since this is otherwise dead time in the IO pipeline that could be better utilized.  This kind of background writeout shouldn't trigger a cache flush each, so that multiple writes can be aggregated more efficiently.

Lustre has always been more aggressive than the VM in starting writeout when there are good-sized chunks of data to me written, or if there are a lot of small files that are not being modified, and this significantly improves performance when IO is bursty, which it is in most real-world cases.

Cheers, Andreas





