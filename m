From: Viji V Nair <viji@fedoraproject.org>
Subject: optimising filesystem for many small files
Date: Sat, 17 Oct 2009 12:29:40 +0530
Message-ID: <84c89ac10910162359j5a49964co7c191dffbce9eb28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f171.google.com ([209.85.216.171]:63692 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZJQG7f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 02:59:35 -0400
Received: by pxi1 with SMTP id 1so4136pxi.33
        for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2009 23:59:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

System : Fedora 11 x86_64
Current Filesystem: 150G ext4 (formatted with "-T small" option)
Number of files: 50 Million, 1 to 30K png images

We are generating these files using a python programme and getting
very slow IO performance. While generation there in only write, no
read. After generation there is heavy read and no write.

I am looking for best practices/recommendation to get a better performance.

Any suggestions of the above are greatly appreciated.

Viji
