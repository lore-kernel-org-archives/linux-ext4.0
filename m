From: suntrop@web.de
Subject: Re: File limit inside a single directory
Date: Thu, 12 Feb 2015 21:35:01 +0100
Message-ID: <trinity-20e5ee6b-70fc-4d05-ab5d-5b4b8a632c47-1423773301597@3capp-webde-bs55>
References: <trinity-2286fbea-64f2-4a0a-b0a7-2d7fc4f6f180-1423768604697@3capp-webde-bs55>,
 <54DD0091.1050104@redhat.com>
 <trinity-18fd0cfe-2cce-4517-bfdc-031a7a4a4e80-1423772290927@3capp-webde-bs55>,
 <54DD0B7B.7020002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:49580 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbbBLUfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2015 15:35:05 -0500
In-Reply-To: <54DD0B7B.7020002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cool, that sounds good.

Many thanks!

=C2=A0
=C2=A0
> Thanks for your reply. I=E2=80=99m using CMS ProcessWire which would =
create
> about 500.000 folders for 500 users and 1.000.000 folders for 1000
> users (only in my case and with my setup). All inside one directory.
> No Subfolders. The max filename length is 8 chars. I don=E2=80=99t kn=
ow the
> actual block size my provider chose but assuming 2k or 4k blocks what
> limit would that sum to?

4k is the default...

but w/ 8 chars and even 2k blocks, you can still get around 8 million
entries.

But again: I'm not sure where that will fall off for you performance-wi=
se.

-Eric
=C2=A0
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
