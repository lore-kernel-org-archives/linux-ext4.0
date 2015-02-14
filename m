From: suntrop@web.de
Subject: Re: Re: File limit inside a single directory
Date: Sat, 14 Feb 2015 11:17:09 +0100
Message-ID: <trinity-dc6eb585-f943-49c8-8da6-907e488f6402-1423909029655@3capp-webde-bs16>
References: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55>
 <54DD0091.1050104@redhat.com>,
 <B52A17D2-8AD8-4427-B1D3-2FE6DE21585B@dilger.ca>
 <trinity-232bc979-0b76-4776-a65c-b6697428d0a4-1423846162245@3capp-webde-bs16>,
 <54DE3442.90707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Andreas Dilger" <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Eric Sandeen" <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:51071 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbbBNKRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Feb 2015 05:17:13 -0500
In-Reply-To: <54DE3442.90707@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for confusion, but now I am confused :-) My setup will be like
/files/
/files/1/
/files/2/
/files/3/
(...)
/files/24244/
(...)
/files/113524/

Thus all folders reside within the /files/ directory (can't change that=
).=20
What happens when the max link count reach 32,000 and I create more fol=
ders? Will this result in any errors or problems? I=E2=80=99m using ext=
3. Is the only consequence that the links aren=E2=80=99t counting up an=
y more, like ext4?
=C2=A0
=C2=A0

Gesendet:=C2=A0Freitag, 13. Februar 2015 um 18:28 Uhr
Von:=C2=A0"Eric Sandeen" <sandeen@redhat.com>
An:=C2=A0suntrop@web.de, "Andreas Dilger" <adilger@dilger.ca>
Cc:=C2=A0"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Betreff:=C2=A0Re: File limit inside a single directory
On 2/13/15 10:49 AM, suntrop@web.de wrote:
> Thanks guys. I was afraid of having a couple 100K (at most). The
> server support team told me not to have more than 10 to 20K. There
> seems to be a misconception (for me and people from the CMS) about
> the 32K subdirectory limit, but this ins't for files/folders within a
> single directory but rather nested directories like /1/2/3.../32000

You've confused things a bit here, FWIW.

The 32k (well, 32000 because, sure) limit on ext3 is max link count;
each subdirectory increases the link count on its parent, but only
its parent. It's not about deep nesting, or about files in a dir.
It's only about subdirs in a parent dir.

# mkdir dir
# stat dir | grep Links
Device: fd06h/64774d Inode: 2490391 Links: 2 // . and .. entries
# mkdir dir/subdir1 dir/subdir2 dir/subdir3
# stat dir | grep Links
Device: fd06h/64774d Inode: 2490391 Links: 5
# mkdir dir/subdir1/subsubdir1 dir/subdir1/subsubdir2 dir/subdir1/subsu=
bdir3
# stat dir | grep Links
Device: fd06h/64774d Inode: 2490391 Links: 5

ext4 bumped that max to 64000, and just stops counting if that number
gets exceeded...

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
