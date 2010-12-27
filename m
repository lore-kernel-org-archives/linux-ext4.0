From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Atomic file data replace API
Date: Mon, 27 Dec 2010 12:51:54 +0100
Message-ID: <AANLkTi=qpQfwZ1vfRjKE063tVvbz0VLmroO_kkvz+N+-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39040 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab0L0Lvz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 06:51:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Since non-durable appears to be controversial, let's consider the case
without that aspect.

Since the introduction of ext4, some apps/users have had issues with
file corruption after a system crash. It's not a bug in the FS AFAIK
and it's not exclusive to ext4.
Writing a temp file, fsync, rename is often proposed.
But how does one preserve meta-data, including file owner?

Olaf
