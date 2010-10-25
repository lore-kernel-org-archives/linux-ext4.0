From: Filipe David Manana <fdmanana@apache.org>
Subject: question about fsync
Date: Mon, 25 Oct 2010 12:49:36 +0100
Message-ID: <AANLkTinFkS1Uf+GJT+SE43KpqoUWyJERBFTzxKyLgX+u@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37063 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab0JYLti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 07:49:38 -0400
Received: by fxm16 with SMTP id 16so2822049fxm.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Oct 2010 04:49:37 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've recently seen code that does the following:

- opens a file (write append mode) and writes data to it
- opens a 2nd file descriptor for that same file (write append mode as
well) and does an fsync call on this 2nd file descriptor
- closes the 2nd file descriptor
- continues writing to the 1st file descriptor
- etc

Is there a risk that some of the data might not get fsynced to disk? I
mean, is it possible that the 2nd file descriptor doesn't have all the
same metadata as the first one?

Thanks.

--=20
=46ilipe David Manana,
fdmanana@gmail.com, fdmanana@apache.org

"Reasonable men adapt themselves to the world.
=C2=A0Unreasonable men adapt the world to themselves.
=C2=A0That's why all progress depends on unreasonable men."
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
