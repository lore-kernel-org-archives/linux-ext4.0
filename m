From: Dietrich Hoppe <dietrich.hoppe@arcor.de>
Subject: ext4: Onchange?
Date: Mon, 1 May 2017 21:51:50 +0200 (CEST)
Message-ID: <188768648.246792.1493668310841@mail.vodafone.de>
Reply-To: Dietrich Hoppe <dietrich.hoppe@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vsmx012.vodafonemail.xion.oxcs.net ([153.92.174.90]:37969 "EHLO
        vsmx012.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750830AbdEAT7U (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 May 2017 15:59:20 -0400
Received: from vsmx004.vodafonemail.xion.oxcs.net (unknown [192.168.75.198])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTP id 412AF40042A
        for <linux-ext4@vger.kernel.org>; Mon,  1 May 2017 19:51:53 +0000 (UTC)
Received: from app-31.app.xion.oxcs.net (app-31.app.xion.oxcs.net [10.10.1.31])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTPA id EE77C380092
        for <linux-ext4@vger.kernel.org>; Mon,  1 May 2017 19:51:50 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

is there any way to register an OnChange-function, that is called by the ext4 file system whenever a change occurs (i.e. create, delete, rename, move a file).

Regards
Dietrich Hoppe
