From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: Bug in ext4/btrfs fallocate?
Date: Wed, 29 Dec 2010 10:02:27 +0100
Message-ID: <4D1AF923.1090502@gmail.com>
References: <4D1A0B1C.70406@gmail.com> <6A86E6B8-E14E-484B-BBF5-F3C580337661@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	tytso@mit.edu, chris.mason@oracle.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <6A86E6B8-E14E-484B-BBF5-F3C580337661@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Il 29/12/2010 07:46, Andreas Dilger ha scritto:
> On 2010-12-28, at 09:06, Marco Stornelli wrote:
>> it seems that ext4/btrfs code for fallocate doesn't check for
>> immutable/append inode flag.
> 
> fallocate() probably shouldn't be allowed for immutable files, but it makes a lot of sense to call fallocate() on append-only files to avoid fragmentation, though it should only be called with the KEEP_SIZE flag.
> 
> Cheers, Andreas
> 

It seems that only ocfs2 does that check, however I think not checking
for immutable flag is an error, for the append case maybe you're right,
doing this operation on append-only files has got sense.

Marco
