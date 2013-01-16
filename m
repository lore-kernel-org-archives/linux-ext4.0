From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: debuge2fs not displaying /dev folder
Date: Wed, 16 Jan 2013 21:16:14 +0530
Message-ID: <CAD6i1fKA6T93OybrVmhy0o5_AW6k4JGJH9LV=xqjE+7OQP+L+A@mail.gmail.com>
References: <CAD6i1f+GzTqewnV=2OefPTGT8YFzNo6+zmoPvxuJXMb9r0ABng@mail.gmail.com>
 <CAD6i1f+p0-W2Pf-Pcf6phTNqrzn6h3OG+zXM3nc9hULdKq1zvw@mail.gmail.com> <20130115201442.GI17719@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33543 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3APPqh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2013 10:46:37 -0500
Received: by mail-ee0-f44.google.com with SMTP id l10so718911eei.3
        for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2013 07:46:36 -0800 (PST)
In-Reply-To: <20130115201442.GI17719@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Wed, Jan 16, 2013 at 1:44 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> Are you sure you don't have a pseudo-filesystem mounted on top of
> /dev?
>
> What does "df /dev" report.  If it's something like this, you are
> using a pseudo-filesystem for /dev:
>
> % df /dev
> Filesystem     1K-blocks  Used Available Use% Mounted on
> udev               10240     0     10240   0% /dev
>

Thanks ! I booted into live cd and listed the files in the unmounted
/dev and I can see the exact same number of files as shown by debugfs.

Regards.
