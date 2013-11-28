From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23 no space left on device
Date: Thu, 28 Nov 2013 11:15:57 +0100
Message-ID: <CAMuHMdWNvnKhJSBmR68EEMZHUuhzkAgWSLz=6eruhcfYKk2Y2A@mail.gmail.com>
References: <CAMuHMdWgMrNQqq84AK+CGF6VFnLs38O-vyye4MFKNUO7b8iFMw@mail.gmail.com>
	<20131127222345.GB27330@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46705 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3K1KP6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Nov 2013 05:15:58 -0500
In-Reply-To: <20131127222345.GB27330@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 27, 2013 at 11:23 PM, Jan Kara <jack@suse.cz> wrote:
> On Wed 27-11-13 16:50:14, Geert Uytterhoeven wrote:
>> To reduce kernel size, I disabled both CONFIG_EXT2_FS and
>> CONFIG_EXT3_FS, and enabled CONFIG_EXT4_USE_FOR_EXT23.
>>
>> Unfortunately the system behaves badly afterwards. It seems the file system
>> is considered full: new files can be created, but no data can be written.
>> Note that the file system is almost full, but root can still write more data
>> using the real ext3 filesystem driver.
>>
>> This is a v3.13-rc1-ish kernel.
>>
>> Diff of dmesg and output of a few operations below:
>   Thanks for report. Maybe the easiest would be if you gathered fs metadata
> using "e2image -r <fs-device>", compressed it and made it available for
> download. We can then debug ourselves where the accounting goes wrong.

Dump from the live image, so it needs journal recovery:

http://users.telenet.be/geertu/Download/hda1.e2i.bz2

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
