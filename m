From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is greater
 than 0
Date: Mon, 2 Jul 2012 16:51:43 +0530
Message-ID: <CAOiN93kzvKVDzSJ13HJZDh9ANt3UaBy0o_QHNKCSHHTizjtY0w@mail.gmail.com>
References: <1339638836-19990-1-git-send-email-ashish.sangwan2@gmail.com>
	<CAKYAXd_g_vgAmyD4jyUqz0u=vaSTAKFqZz0sqhM+2+hy1Z85ug@mail.gmail.com>
	<CAOiN93=BKyGKtpLng-ddX0RFUOdHCaxHi2O26GFokdT19xad2g@mail.gmail.com>
	<alpine.LFD.2.00.1207021110530.24050@dhcp-1-248.brq.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b2ed96bb2024704c3d7009c
Cc: sandeen@redhat.com, Ted Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51601 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2GBLVo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jul 2012 07:21:44 -0400
In-Reply-To: <alpine.LFD.2.00.1207021110530.24050@dhcp-1-248.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--047d7b2ed96bb2024704c3d7009c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I will try to elaborate more about the problem and steps to reproduce:
Linux version 3.4.0 on X86 box.

Step1:
First create a small partition as it would be easy to fragment quickly.
The main intent for fragmenting the partition is to create a file with
at least 2 extent indexes.
You can also choose some other method to create such a file.
I created 200Mb partition and while formating used blocksize as 4KB
and used attached script to fragment.
This script fragments the partition such that each extent is exactly
6FS blocks OR 24KB in length.
Linux#> ./fragment.sh /mnt/
6+0 records in
6+0 records out
24576 bytes (24.0KB) copied, 0.087997 seconds, 272.7KB/s
cp: write error: No space left on device
Partition filled
rm: can't remove '/mnt//file1.7564': No such file or directory
fragmented partition /mnt/ with 24KB files

Step2:
Create a file with 342 extents i.e 2 extent indexes
[root@sputnik ashish]# dd if=3Dlinux-3.4.tar.bz2 of=3Dcheck_1 bs=3D24576 co=
unt=3D342
342+0 records in
342+0 records out
8404992 bytes (8.4 MB) copied, 0.0913289 s, 92.0 MB/s
[root@sputnik ashish]# cp check_1 /mnt/check_2
[root@sputnik ashish]# debugfs  /dev/sdb1
debugfs 1.41.14 (22-Dec-2010)
debugfs:  dump_extents check_2
Level Entries       Logical      Physical Length Flags
 0/ 1   1/  2     0 -  2039 32792             2040
 1/ 1   1/340     0 -     5  5771 -  5776       6
 1/ 1   2/340     6 -    11  5783 -  5788      6
<------- continue like wise till 340 ------------->
 1/ 1 340/340  2034 -  2039  9835 -  9840   6
 0/ 1   2/  2  2040 -  2051  5764              12
 1/ 1   1/  2  2040 -  2045  9847 -  9852     6
 1/ 1   2/  2  2046 -  2051  9859 -  9864     6

Step3: Punch hole at offset 4KB and length of hole is also 4KB
There is attached fallocate.c
[root@sputnik ashish]# ./fallacote.x86 /mnt/check_2
ret =3D 0
[root@sputnik ashish]#

Check extent tree:
[root@sputnik ashish]# debugfs  /dev/sdb1
debugfs 1.41.14 (22-Dec-2010)
debugfs:  dump_extents check_2
Level Entries       Logical      Physical Length Flags
 0/ 1   1/  3     0 -     5 32792                 6
 1/ 1   1/  2     0 -     1  5771 -  5772      2
 1/ 1   2/  2     2 -     5  5773 -  5776      4
 0/ 1   2/  3     6 -  2039  9871           2034
 1/ 1   1/339     6 -    11  5783 -  5788    6
<------- continue like wise till 339 ------------->
 1/ 1 339/339  2034 -  2039  9835 -  9840   6
 0/ 1   3/  3  2040 -  2051  5764             12
 1/ 1   1/  2  2040 -  2045  9847 -  9852    6
 1/ 1   2/  2  2046 -  2051  9859 -  9864    6

It is clearly visible that punching hole just split the first extent into 2
but failed to remove the required blocks.

Step4: To cross check, take diff of 2 files.
[root@sputnik ashish]# diff check_1 /mnt/check_2
[root@sputnik ashish]#

The 2 files are exactly same.

After applying this patch, correct results will be observed.

On Mon, Jul 2, 2012 at 2:42 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.co=
m> wrote:
> On Mon, 2 Jul 2012, Ashish Sangwan wrote:
>
>> Date: Mon, 2 Jul 2012 11:03:26 +0530
>> From: Ashish Sangwan <ashishsangwan2@gmail.com>
>> To: sandeen@redhat.com, Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>,
>>     Ted Tso <tytso@mit.edu>
>> Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
>>     Namjae Jeon <linkinjeon@gmail.com>
>> Subject: Re: [PATCH v2] ext4: fix hole punch failure when depth is great=
er
>>     than 0
>>
>> Hi Ted, Lukas, Eric,
>>
>> Did any of you get a chance to look at it?
>
> I am sorry for the delay. I have been trying to reproduce this
> problem without any success so far. But is was on ppc64 machine, so
> I'll try that on x86_64 and then review the patch.
>
> Thanks!
> -Lukas
>
>>
>> On Fri, Jun 22, 2012 at 6:19 AM, Namjae Jeon <linkinjeon@gmail.com> wrot=
e:
>> > Hi. Eric.
>> >
>> > This is the patch for punch hole issue.
>> >
>> > Thanks.
>> >
>>

--047d7b2ed96bb2024704c3d7009c
Content-Type: text/x-csrc; charset=US-ASCII; name="fallacote.c"
Content-Disposition: attachment; filename="fallacote.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h45git9m0

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMv
c3RhdC5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDx1
bmlzdGQuaD4KI2RlZmluZSBGQUxMT0NfRkxfUFVOQ0hfSE9MRQkJMHgwMgojZGVmaW5lIEZBTExP
Q19GTF9LRUVQX1NJWkUJCTBYMDEKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQp7Cglp
bnQgZmQ7CglpbnQgbW9kZSA9IDA7IAoJaW50IHJldCA9IDA7CiAgICAgICAgaWYgKGFyZ2MgPCAy
KSB7CiAgICAgICAgICAgICAgICBfZXhpdCgxKTsKICAgICAgICB9Cgltb2RlID0gKG1vZGUgfCBG
QUxMT0NfRkxfUFVOQ0hfSE9MRSB8IEZBTExPQ19GTF9LRUVQX1NJWkUpOyAgCglpZiAoKGZkID0g
b3Blbihhcmd2WzFdLCBPX1JEV1IpKSA8IDApIHsKICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVy
ciwgIkNhbm5vdCBvcGVuIGZpbGUgJXNcbiIsIGFyZ3ZbMV0pOwoJCV9leGl0KDEpOwogICAgICAg
IH0KCXJldD0gZmFsbG9jYXRlKGZkLG1vZGUsNDA5Niw0MDk2KTsKCWlmKCByZXQgIT0gMCkKCQlw
ZXJyb3IoIkZhbGxvY2F0ZSBmYWlsXG4iKTsKCXByaW50ZigicmV0ID0gJWRcbiIscmV0KTsKCWNs
b3NlKGZkKTsKCXJldHVybiAwOwp9Cgo=
--047d7b2ed96bb2024704c3d7009c
Content-Type: application/x-sh; name="fragment.sh"
Content-Disposition: attachment; filename="fragment.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h45gkqls1

aWY9L2Rldi96ZXJvIG9mPTI0a2IgYnM9NDA5NiBjb3VudD02CmluZGV4PTAKd2hpbGUgWyAkPyA9
PSAwIF0KZG8KaW5kZXg9JCgoJGluZGV4ICsgMSkpCmNwIDI0a2IgJDEvZmlsZTEuJGluZGV4CmRv
bmUKZWNobyAiUGFydGl0aW9uIGZpbGxlZCIKc3luYwppbmRleD0wCndoaWxlIFsgJD8gPT0gMCBd
CmRvCmluZGV4PSQoKCRpbmRleCArIDIpKQpzeW5jCnJtICAkMS9maWxlMS4kaW5kZXgKZG9uZQpz
eW5jCmVjaG8gImZyYWdtZW50ZWQgcGFydGl0aW9uICQxIHdpdGggMjRLQiBmaWxlcyIK
--047d7b2ed96bb2024704c3d7009c--
