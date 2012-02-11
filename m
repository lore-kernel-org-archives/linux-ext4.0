From: Rudolf Zran <rudolfzran@yahoo.com>
Subject: [SOLVED] (was "Re: Restoring filenames from partly damaged ext4-filesystem")
Date: Sat, 11 Feb 2012 17:33:30 +0000 (GMT)
Message-ID: <1328981610.63291.YahooMailNeo@web132402.mail.ird.yahoo.com>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
Reply-To: Rudolf Zran <rudolfzran@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm24-vm0.bullet.mail.ird.yahoo.com ([212.82.109.239]:26709 "HELO
	nm24-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751351Ab2BKRdb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Feb 2012 12:33:31 -0500
In-Reply-To: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi List!

In an offlist reply someone recommended me ext4magic (see
http://developer.berlios.de/projects/ext4magic ).

Like magic it recovered complete directory hierarchies with filenames,
timestamps, even ownership and permissions for more than 300GB of the
deleted data.

I can recommend this to everybody who accidently destroyed parts of
his filesystem. In contrast to fsck ext4magic doesn't try to repair,
 but just extracts the data completely in read only mode (feelslike
"tar xf" actually :).It's easier to use and understand and way more
effective when it comesto recovery. ext4magic shouldn't be missing
in any good recovery collection.

Thanks to all helping me out in this case.

Have a nice weekend, Rudolf.

