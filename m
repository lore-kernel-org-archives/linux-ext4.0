From: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Sun, 15 Nov 2009 19:15:54 -0200
Message-ID: <4B006F8A.8000606@diamondcut.com.br>
References: <4AFC14D6.7080700@diamondcut.com.br>	<20091112153017.GA32122@mit.edu> <878wea84lq.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Weimer <fw@deneb.enyo.de>, Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-04.mandic.com.br ([200.225.81.151]:35666 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZKOVPq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Nov 2009 16:15:46 -0500
Received: from 189.114.151.225.dynamic.adsl.gvt.net.br (HELO [192.168.1.104]) (4s3fxNW2pdTI28e3yZjKop5Ok6I=@[189.114.151.225])
          (envelope-sender <yamane@diamondcut.com.br>)
          by smtp-04.mandic.com.br (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-ext4@vger.kernel.org>; 15 Nov 2009 21:15:48 -0000
In-Reply-To: <878wea84lq.fsf@mid.deneb.enyo.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13-11-2009 20:03, Florian Weimer wrote:
> * Theodore Tso:
>> That being said, though, it shouldn't be necessary to avoid using a
>> journal on the Intel SSD.  Intel says that laptop will last at least 5
>> years with 10GB worth of writes per day, and that's a huge amount.  I
>> have an X25-M SSD in my laptop, using an ext4 file system and with the
>> journal enabled, and since the file system was created 266 days ago,
>> when I put my X25-M into service, the drive has seen 570GB worth of
>> writes, so I'm averaging 2.14 GB writes per day.
>
> That really depends on the software you use.  Just fetching mail on my
> machine causes about 500 MB of data written to disk.  That's because
> I'm using Gnus with nnml and slightly large mail folders and Gnus
> rewrites those index files from scratch each time new mail for a
> folder arrives.  I should really consider this a bug and fix it, but I
> haven't yet found a good solution.

So sorry for this stupid question, but...
How can I know the average writes per day?
I try run smart, but it not help me:

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   3 Spin_Up_Time            0x0000   100   000   000    Old_age 
Offline      -       0
   4 Start_Stop_Count        0x0000   100   000   000    Old_age 
Offline      -       0
   5 Reallocated_Sector_Ct   0x0002   100   100   000    Old_age 
Always       -       0
   9 Power_On_Hours          0x0002   100   100   000    Old_age 
Always       -       229
  12 Power_Cycle_Count       0x0002   100   100   000    Old_age 
Always       -       62
192 Power-Off_Retract_Count 0x0002   100   100   000    Old_age   Always 
       -       48
232 Unknown_Attribute       0x0003   100   100   010    Pre-fail  Always 
       -       0
233 Unknown_Attribute       0x0002   099   099   000    Old_age   Always 
       -       0
225 Load_Cycle_Count        0x0000   200   200   000    Old_age 
Offline      -       44867
226 Load-in_Time            0x0002   255   000   000    Old_age   Always 
       -       0
227 Torq-amp_Count          0x0002   000   000   000    Old_age   Always 
       -       0
228 Power-off_Retract_Count 0x0002   000   000   000    Old_age   Always 
       -       0

Reagards,
Renato S. Yamane
