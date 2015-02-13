From: suntrop@web.de
Subject: Re: Re: File limit inside a single directory
Date: Fri, 13 Feb 2015 17:49:22 +0100
Message-ID: <trinity-232bc979-0b76-4776-a65c-b6697428d0a4-1423846162245@3capp-webde-bs16>
References: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55>
 <54DD0091.1050104@redhat.com>,
 <B52A17D2-8AD8-4427-B1D3-2FE6DE21585B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Eric Sandeen" <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Andreas Dilger" <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:63651 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbbBMQt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Feb 2015 11:49:28 -0500
In-Reply-To: <B52A17D2-8AD8-4427-B1D3-2FE6DE21585B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks guys. I was afraid of having a couple 100K (at most). The server=
 support team told me not to have more than 10 to 20K. There seems to b=
e a misconception (for me and people from the CMS) about the 32K subdir=
ectory limit, but this ins't for files/folders within a single director=
y but rather nested directories like /1/2/3.../32000

Again, many thanks!
=C2=A0

Gesendet:=C2=A0Freitag, 13. Februar 2015 um 01:55 Uhr
Von:=C2=A0"Andreas Dilger" <adilger@dilger.ca>
An:=C2=A0"Eric Sandeen" <sandeen@redhat.com>
Cc:=C2=A0"suntrop@web.de" <suntrop@web.de>, "linux-ext4@vger.kernel.org=
" <linux-ext4@vger.kernel.org>
Betreff:=C2=A0Re: File limit inside a single directory
We started to have problems in our testing around 15M entries in one di=
rectory (depends on hashing, add/remove cycles), but 10-12M entries is =
probably safe unless the filenames are long (e.g. above 32 chars).

Cheers, Andreas

> On Feb 12, 2015, at 12:35, Eric Sandeen <sandeen@redhat.com> wrote:
>
>> On 2/12/15 1:16 PM, suntrop@web.de wrote:
>> Hello, i=E2=80=99m using a CMS which puts many files inside a single
>> directory. I=E2=80=99m wondering what the maximum number of files is=
 which
>> can reside inside said directory. Is there a number which should not
>> be exceeded on account of performance reasons e.g. Is there a
>> difference between ext3 and ext4?
>>
>> Thanks!
>
> for htree directories, you will be limited by the max size of the tre=
e, which currently is of limited depth. That limit then depends on bloc=
k size and filename lengths.
>
> for 4k blocks, and 40 char names, you max out at around 20 million di=
rectory entries, if my old spreadsheet is still correct.
>
> That limit is the same for ext3 and ext4.
>
> performance-wise, to be honest, I'm not sure. how many inodes are you=
 talking about?
>
> -Eric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
