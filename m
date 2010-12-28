From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Bug in ext4/btrfs fallocate?
Date: Tue, 28 Dec 2010 17:06:52 +0100
Message-ID: <4D1A0B1C.70406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	tytso@mit.edu, chris.mason@oracle.com
To: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

it seems that ext4/btrfs code for fallocate doesn't check for
immutable/append inode flag. I think it's possible to do an fallocate
operation even if the immutable flag is turned on. You can think about
this case: an application opens a file for read/write, meanwhile a user
set the immutable flag and then the application calls fallocate. Other
cases shouldn't happen because if the immutable flag is turned on before
the application opens the file, then the application can't open the file
in read/write mode and therefore it can't do an fallocate operation.
Sincerely I haven't tried but I saw this kind of error in my own fs that
have a similar code.

Regards,

Marco
