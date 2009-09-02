From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH] libext2fs: use proper functions to set/clear block group
	flags
Date: Wed, 2 Sep 2009 14:26:47 -0700
Message-ID: <150c16850909021426s7ea705a9ube8aa8bbbc77aa0c@mail.gmail.com>
References: <4A9ED75A.7030406@redhat.com> <4A9EE06B.5010500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Ric Wheeler <rwheeler@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:42708 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZIBVdc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Sep 2009 17:33:32 -0400
Received: by pzk42 with SMTP id 42so1037486pzk.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2009 14:33:34 -0700 (PDT)
In-Reply-To: <4A9EE06B.5010500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 2, 2009 at 2:15 PM, Eric Sandeen<sandeen@redhat.com> wrote:
> Well, it resolves that problem, but further testing reveals another
> lurking behind it, so expect more patches ;)

Thanks for the update. :)  My test just finished with, unfortunately,
the same results.

-Justin
