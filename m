From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 07:23:14 -0400
Message-ID: <4D7F4C22.9060801@gmail.com>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <8239molspy.fsf@mid.bfk.de> <4C11D2E5-75CD-4A9F-A534-EEC16CDD836B@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Weimer <fweimer@bfk.de>, Eric Sandeen <sandeen@redhat.com>,
	Phillip Susi <psusi@cfl.rr.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37009 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab1COLXS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 07:23:18 -0400
Received: by vxi39 with SMTP id 39so429802vxi.19
        for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 04:23:17 -0700 (PDT)
In-Reply-To: <4C11D2E5-75CD-4A9F-A534-EEC16CDD836B@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/15/2011 07:06 AM, Theodore Tso wrote:
> On Mar 15, 2011, at 3:59 AM, Florian Weimer wrote:
>
>> * Eric Sandeen:
>>
>>> No, because htree (dir_index) dirs returns names in hash-value
>>> order, not inode number order.  i.e. "at random."
>>>
>>> As you say, sorting by inode number will work much better...
>> The dpkg folks tested this and it turns out that you get better
>> results if you open the file and use FIBMAP to get the first block
>> number, and sort by that.  You could sort by inode number before the
>> open/fstat calls, but it does not seem to help much.
> It depends on which problem you are trying to solve.  If this is a cold
> cache situation, and the inode cache is empty, then sorting by inode
> number will help since otherwise you'll be seeking all over just to
> read in the inode structures.   This is true for any kind of readdir+stat
> combination, whether it's ls -l, or du or readdir + FIBMAP (I'd
> recommend using FIEMAP these days, though).
>
> However, if you need to suck in the information for a large number of
> small files (such as all of the files in /var/lib/dpkg/info), then sure, sorting
> ont he block number can help reduce seeks on the data blocks side of
> things.
>
> So in an absolute cold cache situations, what I'd recommend is readdir,
> sort by inode, FIEMAP,  sort by block, and then read in the dpkg files.
> Of course an RPM partisan might say, "it would help if you guys had
> used a real database instead of ab(using) the file system.  And then
> the dpkg guys could complain about what happens when RPM has to
> deal with corrupted rpm database, and how this allows dpkg to use
> shell scripts to access their package information.  Life is full of tradeoffs.
>
> -- Ted
>

I have tested both sorting techniques with very large directories.

Most of the gain came with the simple sorting by inode number, but of course 
this relies on the file system allocation policy having a correlation between 
the inode numbers and layout (i.e., higher inode number correspond to higher 
block numbers).

Note that you can get the inode number used in this sorting without doing any 
stat calls.

Sorting by first block number also works well, but does have that extra syscall 
(probably two - open & fibmap?) per file.

Ric

