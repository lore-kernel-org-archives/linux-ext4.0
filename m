From: Jitesh Shah <jitesh.1337@gmail.com>
Subject: Reproducible block structure
Date: Mon, 9 Dec 2013 21:03:23 -0800
Message-ID: <CAO_9QQcOSgUA84ewb=PANikU+MzeTmmeHnPeLd2SHQ_46sUi8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:64690 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3LJFDX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 00:03:23 -0500
Received: by mail-ob0-f175.google.com with SMTP id uz6so4805052obc.34
        for <linux-ext4@vger.kernel.org>; Mon, 09 Dec 2013 21:03:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello all,
Assuming I have the latest ext4 system, I have a question ->
Scenario -> I have 5 HDDs on which I burn the same block image on.
These HDDs are usually mounted RO when used in production. For
upgrading, I connect each one to an isolated machine, mount it as RW
and run a script to update files (basically add, delete, modify
files).

Now, if the script is ran in the SAME way for all 5 HDDs, is it
guaranteed that these HDDs will be same at the block level too? (i.e.
block allocation/deallocation will follow the same pattern). Assume
single-core system with only one process modifying the HDD in
predetermined order.

If there is no way to provide such a guarantee in a default ext4
install, is there an ext4 option (ordered?) which can provide this
guarantee?

Why do I ask -> I am tinkering with the idea of block level
verification of images. If the above guarantees can be provided, I can
easily hash the raw HDD for verification purposes.

Thanks,
Jitesh

PS: I am not subscribed to the mailing list, so please include my id
in the response if your email client does not put it there already!
