From: jehan procaccia <jehan.procaccia@it-sudparis.eu>
Subject: Re: howto downgrade ext4 to ext3
Date: Tue, 22 Sep 2009 17:31:06 +0200
Message-ID: <4AB8EDBA.1080108@it-sudparis.eu>
References: <4AB39EC5.6070107@it-sudparis.eu> <20090918175851.GH26991@mit.edu> <4AB3D060.2020101@redhat.com> <20090918193456.GA27303@mit.edu> <4AB3F9C4.1010702@it-sudparis.eu> <20090918225834.GC28781@mit.edu> <4AB53F3E.4040007@it-sudparis.eu> <4AB581EF.7050701@redhat.com>
Reply-To: jehan.procaccia@it-sudparis.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:39266 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZIVPbK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Sep 2009 11:31:10 -0400
In-Reply-To: <4AB581EF.7050701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen a =E9crit :
> jehan procaccia wrote:
>> Other inodes incriminated showed the same result -> over-quota . So=20
>> if user data finally cannot be written, after all ... quota wouldn't=
=20
>> allow it anyway .
>
> The unfortunate thing in your situation though is that the user=20
> -thought- it did get written, just FYI.
>
> When quota is working properly, the denial is obvious up front.
OK, indeed it's not fair for the users !
I had the time to experiment an ext4 FS mounted with -nodelalloc, and=20
now quotas seems to work fine with it ;-) .

here's a test on a FS  mounted with -nodelalloc
while writing with dd for an amount of data between interval soft 300M=20
and hard  330M, it worked fine:

[test@b03-05 ~]$ dd if=3D/dev/zero of=3D./big-101M.dd bs=3D1024 count=3D=
101000
103424000 octets (103 MB) copi=C3=A9s, 9,06256 s, 11,4 MB/s
$ quota -s test
/dev/mapper/VolGroup03S2IA-LogVolS2ia01
                  317M*   293M    323M   7days    1760       0       0

Then, user "test" writes another 100 Mb and fails as expected :

[test@b03-05 ~]$ dd if=3D/dev/zero of=3D./big-102M.dd bs=3D1024 count=3D=
102000
dd: fermeture du fichier de sortie `./big-102M.dd': D=C3=A9bordement du=
=20
quota d'espace disque
$ quota -s test
/dev/mapper/VolGroup03S2IA-LogVolS2ia01
                  323M*   293M    323M   6days    1761       0       0
[root@gizeh /disk00/test/test]
$ ll big*
-rw-r--r-- 1 test mci 103424000 Sep 21 11:11 big-101M.dd
-rw-r--r-- 1 test mci  35729408 Sep 21 11:13 big-102M.dd

however in terms of performances, it seriously drops (nearly 50% !) =20
with -nodelalloc on the NFS disk server, here's a simple local dd write=
=20
test:

ext4 -nodelalloc
[root@gizeh /disk00]
$ dd if=3D/dev/zero of=3D./big-300M.dd bs=3D1024 count=3D300000
307200000 bytes (307 MB) copied, 1.20125 seconds, 256 MB/s

ext4 -delalloc
[root@gizeh /disk01]
$ dd if=3D/dev/zero of=3D./big-300M.dd bs=3D1024 count=3D300000
307200000 bytes (307 MB) copied, 0.752382 seconds, 408 MB/s

however, the same test from an NFS workstation shows very small=20
differences between partition mounted with nodelalloc and delalloc:

-nodealloc + NFS
$ dd if=3D/dev/zero of=3D./big-100M.dd bs=3D1024 count=3D100000
102400000 octets (102 MB) copi=E9s, 9,09703 s, 11,3 MB/s

delalloc + NFS
$ dd if=3D/dev/zero of=3D./big-100M.dd bs=3D1024 count=3D100000
102400000 octets (102 MB) copi=E9s, 9,00392 s, 11,4 MB/s

I supose that NFS is the bottleneck !

I will announce a maintenance on that server in order to remount  my 12=
=20
x 200GB partitions with -nodelalloc, if ever performances drops too muc=
h=20
, then I'll probably choose to set quotas off until a redhat kernel=20
package provides a solution .

does 2.6.31 already patche to deal correclty with delalloc and quotas ?

Thanks .

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
