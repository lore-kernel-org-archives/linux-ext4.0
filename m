From: squadra <squadra@gmail.com>
Subject: Re: power loss protection
Date: Sun, 12 Oct 2014 19:53:52 +0200
Message-ID: <CABx==A0U72TayJ9R1ET8-dYke4MYNUZ0E6Fsq9yTjH90JtcUtA@mail.gmail.com>
References: <5435661D.2040905@powercraft.nl>
	<08F28BC7-34FD-46BA-9D91-CC7D57A4A4D5@dilger.ca>
	<20141011231948.GC6262@thunk.org>
	<543A8B33.7020401@adinet.com.uy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	EXT3 Users <ext3-users@redhat.com>
To: Ivan Baldo <ibaldo@adinet.com.uy>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:59638 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaJLRxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Oct 2014 13:53:53 -0400
Received: by mail-qa0-f52.google.com with SMTP id dc16so3649444qab.11
        for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2014 10:53:52 -0700 (PDT)
In-Reply-To: <543A8B33.7020401@adinet.com.uy>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

dunno about any special tools, but misusing a mysql database could be
a good check for this. unplug/reset your device while inserts into the
db are ongoing (dont forget to use innodb for the tables). unplug /
reset your device, boot it up again and take a look into the mysql
log. theres a good chance that innodb gets wrecked... sure, this is
not perfect. but could be a impressive test if it ends like i think.

make sure your mysql instance is configured to be "safe":

http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_in=
nodb_flush_method
http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_in=
nodb_flush_log_at_trx_commit

and enable binlogs + sync binlogs

or in other words: make it as slow as possible :p

On Sun, Oct 12, 2014 at 4:07 PM, Ivan Baldo <ibaldo@adinet.com.uy> wrot=
e:
>     Hello.
>
> El 11/10/14 21:19, Theodore Ts'o escribi=C3=B3:
>>
>> If you are running some workload which is constantly calling fsync(2=
),
>> that will be forcing journal commits, and those turn into cache flus=
h
>> commands that force all state to stable storage.  Now, if you are
>> using CF cards that aren't guaranteed to have power-loss protection
>> (hint: even most consumer grade SSD's do not have power loss
>> protection --- you have to pay $$$ for enterprise-grade SLC SSD's to
>> have power loss protection --- and I'm guessing most CF cards are so
>> cheap that they won't make guarantees that all of their flash metada=
ta
>> are saved to stable store on a power loss event) the fact that you a=
re
>> constantly using fsync(2) may not be providing you with the protecti=
on
>> you want after a power loss event.
>>
>>
>     This got me worried!
>     How can we test if a device really stores all the data safely aft=
er a
> barrier and sudden power loss?
>     Is there a tool for that?
>     I am thinking something along the lines of a tool that does write=
s with
> some barriers in between and then I unplug the device and run the sam=
e tool
> but in a "check mode" that tells me if the requested data before the =
barrier
> is really there.
>     Something sysadmin friendly or maybe even user friendly, but not =
too
> hard to use.
>     Thanks for your insight!
>
> --
> Ivan Baldo - ibaldo@adinet.com.uy - http://ibaldo.codigolibre.net/
> From Montevideo, Uruguay, at the south of South America.
> Freelance programmer and GNU/Linux system administrator, hire me!
> Alternatives: ibaldo@codigolibre.net - http://go.to/ibaldo
>
> _______________________________________________
> Ext3-users mailing list
> Ext3-users@redhat.com
> https://www.redhat.com/mailman/listinfo/ext3-users



--=20
Sent from the Delta quadrant using Borg technology!
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
