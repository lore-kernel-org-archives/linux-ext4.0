From: Julius Schwartzenberg <julius.schwartzenberg@gmail.com>
Subject: Re: e2fsck doesn't finish
Date: Mon, 17 Apr 2017 17:11:55 +0200
Message-ID: <deffb0af-1aaf-bad9-a7e5-64ea39171aa1@gmail.com>
References: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
 <f5fb3216-c52c-fc63-d90b-e6f670843882@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49629 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754028AbdDQPL6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Apr 2017 11:11:58 -0400
In-Reply-To: <f5fb3216-c52c-fc63-d90b-e6f670843882@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Providing an e2image might allow developers to analyze the problem.
> If it's a large filesystem, the qcow output format is most portable.

Here is the e2image:
https://schwart6.home.xs4all.nl/sda4.e2i.bz2

The file is around 150M.
It's made with -s as the file system concerned is actually /home on my
notebook.

Thanks,
Julius
