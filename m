From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: why has "fix ext4_ext_remove_space tree traversal" not been applied?
Date: Tue, 06 Nov 2012 17:01:50 +0400
Message-ID: <871ug6rikh.fsf@openvz.org>
References: <20632.64737.272834.202562@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:45369 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2KFNBx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Nov 2012 08:01:53 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so317885lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 06 Nov 2012 05:01:52 -0800 (PST)
In-Reply-To: <20632.64737.272834.202562@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Nov 2012 10:04:49 -0200, Carlos Carvalho <carlos@fisica.ufpr.br> wrote:
> In 3.6.6 some of the patches of the series "Bunch of DIO/AIO fixes V4"
> by Dmitry Monakhov have been applied but not all. In particular, patch
> 9, "fix ext4_ext_remove_space tree traversal" is not there. We're
> getting hit by the null pointer dereference in our main file servers.
> 
> What's the situation of this patch? Any reason it's not applied?
This bug was already fixed at this moment
See main bug report https://bugzilla.kernel.org/show_bug.cgi?id=47611
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
