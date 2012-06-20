From: Norbert Preining <preining@logic.at>
Subject: Re: Ext4 slow on links
Date: Wed, 20 Jun 2012 12:38:31 +0900
Message-ID: <20120620033831.GA2395@gamma.logic.tuwien.ac.at>
References: <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <4FE14034.6070800@redhat.com> <20120620002014.GA25471@gamma.logic.tuwien.ac.at> <20120620021912.GA26323@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47937 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2FTDih (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2012 23:38:37 -0400
Content-Disposition: inline
In-Reply-To: <4FE14034.6070800@redhat.com> <20120620021912.GA26323@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, hi Eric,

thanks for the answers, here some remarks.

On Di, 19 Jun 2012, Ted Ts'o wrote:
> The inode has room for 60 characters; after that, the symlink target
> gets stored in an external block.  The seek to read in the symlink
> target could be one of the causes of the delay.  The other is

Ok.

> Nothing has changed here between ext2/ext3 and ext4 here, so ext2/ext3
> will behave exactly the same.  There are changes in the block and
> inode allocation algorithms which might make a minor difference, but
> the same is potentially true of a very fragmented file system.

Ok.

Thinking about that, even if I dereference the files, I still am a 
bit surprised. For each file we have the following times:
1- read the inode and determine if it is a link
2- check if link target fits in the the 60chars
3- read the additional block for long link target
4- read the target inode

I assume that the items 1,3, and 4 are the time consuming ones and
about the same time.

Now what I don't understand, why doing a 
	time ls -l >/dev/null
on the directory with the original files takes 1.2s,
but reading the links with ls -l >/dev/null takes 1m13s, both
after reboot on cold cache.

I assume that some data is hashed in the directory inode, so doing
ls -l on the real files only reads the directory inode and not 
each file invividually, while reading all the links read all the
individual files.

Is this the explanation? If not, I cannot imagine any way that reading
a list of links and dereferencing them plus reading the ttargets 
takes 60times as long.

On Di, 19 Jun 2012, Eric Sandeen wrote:
> As Ted said, the targets might be far-flung.  If you do /bin/ls -l instead
> of maybe an aliased ls which stats everything to make pretty colors,
> is that faster?

Might be the problem, but I saw the same with a program doing
opendir readdir etc, so no allias or external program involved.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
NACTION (n.)
The 'n' with which cheap advertising copywriters replace the word
'and' (as in 'fish 'n' chips', 'mix 'n' match', 'assault 'n'
battery'), in the mistaken belief that this is in some way chummy or
endearing.
			--- Douglas Adams, The Meaning of Liff
