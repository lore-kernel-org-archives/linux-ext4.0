From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: Fix 32bit overflow in ext4_ext_find_goal()
Date: Mon, 03 Jan 2011 11:25:58 -0600
Message-ID: <4D2206A6.1080505@redhat.com>
References: <4D05B132.3060402@sx.jp.nec.com> <20110102214031.GA10889@thunk.org> <F02D88CD-7463-4E10-A012-D2CE362D1E88@dilger.ca> <20110103041157.GE11955@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	Kazuya Mio <k-mio@sx.jp.nec.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1ACR0D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Jan 2011 12:26:03 -0500
In-Reply-To: <20110103041157.GE11955@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/02/2011 10:11 PM, Ted Ts'o wrote:
> On Sun, Jan 02, 2011 at 08:35:39PM -0700, Andreas Dilger wrote:
>> It was written that way because HPC applications writing to a shared
>> file normally write to an offset of task_num * task_data_size so
>> they do not overlap, and end up with a dense file. Similarly,
>> bittorrent and parallel FTP clients will write dense files after
>> seeking randomly around the file, and database files often end up
>> dense as well.
>>
>> I'd rather fix the relatively few applications that expect
>> permanently sparse files to use fadvise() to notify the kernel of
>> this.
> 
> Agreed, and I'm not sure there are enough applications that expect
> permanently sparse files that's worth adding a new fadvise().  But if
> we do add a new fadvise(), the default should clearly be the current
> behavior.
> 
> If someone knows of use cases where permanently sparse files are
> common, please let us know!

RPM database files stay sparse (Berkeley DB)

$ pwd
/var/lib/rpm
$ ls -lh Basenames; du -h Basenames
-rw-r--r-- 1 rpm rpm 11M Dec  8 12:55 Basenames
9.1M	Basenames

etc.

-Eric
