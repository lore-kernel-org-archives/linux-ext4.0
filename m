From: Andres Freund <andres@anarazel.de>
Subject: Re: EXT4 ENOSPC Bug
Date: Mon, 16 Feb 2009 16:27:03 +0100
Message-ID: <499985C7.8010302@anarazel.de>
References: <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.anarazel.de ([217.115.131.40]:54400 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZBPP1W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2009 10:27:22 -0500
In-Reply-To: <20090216150156.GD22619@mini-me.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 02/16/2009 04:01 PM, Theodore Tso wrote:
> On Mon, Feb 16, 2009 at 12:37:19PM +0100, Andres Freund wrote:
>> "Luckily", to prove that I am not completly mad I recently found this
>> problem again. On a more recent kernel:
>> 2.6.29-rc3-andres-00498-g68e80d5
>> (upstream 2.6.29 + Theodore's ext4 debug patches)
>>
>> Again I got:
>> open("/home/andres/tt", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) = -1
>> ENOSPC (No space left on device)
>
> So /home/andres/tt does not exist, correct?
yes

 > Does this happen for any
> attempt to create a new zero-length file using the "touch" command?
> (Even in other directories)   Can you append to a file using "cat
> /etc/mailcap>>  some_existing_file"?
Happens at the moment only for not existing files in every directory i 
tried.

> Once this triggers, does it reliably continue to fail if you reboot?
Yes and no. It triggers as long as I don't delete any files:

Out of another mail:

for i in `seq 1 1000`;do touch tmp$i;done
touch: cannot touch `tmp139': No space left on device
...

rm tmp*;for i in `seq 1 200`;do dd if=/dev/zero of=tmp$i bs=1024k 
count=1;done
dd: opening `tmp139': No space left on device
139
..

So, yes, seems to be an inode allocation problem.

> Or does it go away when you reboot?
Reboot fixes it.


Andres
