From: Xiang Wang <xiangw@google.com>
Subject: The flex_bg inode allocator
Date: Fri, 17 Jul 2009 20:38:18 -0700
Message-ID: <d5ca277e0907172038x3dce5f8dx11d6ec4f7b0f3c52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:58164 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbZGRDiX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 23:38:23 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id n6I3cLre022967
	for <linux-ext4@vger.kernel.org>; Sat, 18 Jul 2009 04:38:22 +0100
Received: from ewy11 (ewy11.prod.google.com [10.241.103.11])
	by wpaz21.hot.corp.google.com with ESMTP id n6I3cJtA020354
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2009 20:38:19 -0700
Received: by ewy11 with SMTP id 11so1328846ewy.10
        for <linux-ext4@vger.kernel.org>; Fri, 17 Jul 2009 20:38:19 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Recently I've found out that the flex_bg inode allocator(the
find_group_flex function called by ext4_new_inode) is actually not in
use unless we specify the "oldalloc" option on mount as well as
setting the flex_bg size to be > 1.
Currently, the default option on mount is "orlov".

We would like to know:
1) What's the current status of the flex_bg inode allocator? Will it
be set as a default soon?

2) If not, are there any particular reasons that it is held back? Is
it all because of the worse performance numbers shown in the two
metrics
("read tree total" and "read compiled tree total") in Compilebench?

3) Are there any ongoing efforts and/or future plans to improve it? Or
is there any work in similar directions?

Thanks,
Xiang
