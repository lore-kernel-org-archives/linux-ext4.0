From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: File limit inside a single directory
Date: Thu, 12 Feb 2015 13:35:45 -0600
Message-ID: <54DD0091.1050104@redhat.com>
References: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: suntrop@web.de, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbbBLTfr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2015 14:35:47 -0500
In-Reply-To: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/12/15 1:16 PM, suntrop@web.de wrote:
> Hello, i=E2=80=99m using a CMS which puts many files inside a single
> directory. I=E2=80=99m wondering what the maximum number of files is =
which
> can reside inside said directory. Is there a number which should not
> be exceeded on account of performance reasons e.g. Is there a
> difference between ext3 and ext4?
>=20
> Thanks!

for htree directories, you will be limited by the max size of the tree,=
 which currently is of limited depth.  That limit then depends on block=
 size and filename lengths.

for 4k blocks, and 40 char names, you max out at around 20 million dire=
ctory entries, if my old spreadsheet is still correct.

That limit is the same for ext3 and ext4.

performance-wise, to be honest, I'm not sure.  how many inodes are you =
talking about?

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
