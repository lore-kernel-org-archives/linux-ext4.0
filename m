From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: [PATCH 1/2] Make orphan functions no-op in no-journal mode
Date: Mon, 17 Sep 2012 10:55:31 -0700
Message-ID: <CAOMFOmVvX63Lr7csWXTAS+5v0JVYndoFqMTEvFGXE=EQ3ery6Q@mail.gmail.com>
References: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dmonakhov@openvz.org, Anatol Pomozov <anatol.pomozov@gmail.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36890 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757007Ab2IQRzd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 13:55:33 -0400
Received: by lagy9 with SMTP id y9so4366550lag.19
        for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 10:55:32 -0700 (PDT)
In-Reply-To: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

On Mon, Sep 17, 2012 at 10:47 AM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
> This avoids using shared mutext and thus improves scalability of
> no-journal mode. The goal of this change is similar to 3d287de3b828
> but it avoids mutex usage for all ext4_orphan_del(NULL,..) calls.

This change does the same as 3d287de3b828 but for all
ext4_orphan_del() usages. So 3d287de3b828 can be reverted.
