From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Date: Sun, 20 Nov 2011 07:22:29 +0900
Message-ID: <CAKYAXd-pT9aW3UA5Wby=X0N0s52jzwfmsdWCvoO3-n4bbJbSyQ@mail.gmail.com>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
	<47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
	<alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com>
	<CADDb1s1pLddZ4TQciL=yO-17WwQDyLmzP1E8U0UsyiQqez8Q8A@mail.gmail.com>
	<CAKYAXd9wCJFuJZ8uxHESuq92G9EUc0Dq0ejAwbJk0OrwhCcVCA@mail.gmail.com>
	<8343168C-D5F7-43E4-B614-45FBAF5B29A7@mit.edu>
	<A5A56693-9C4C-4957-AAA5-3D1BD8AA7DCE@mit.edu>
	<CAKYAXd99NrOC77=p31nax223UOxOONv3_JcLXUpXign8=58Vxw@mail.gmail.com>
	<0912364C-C313-4BCA-9EE2-73F55FE012E6@mit.edu>
	<CAKYAXd91gcPbfAqRRkW7HhxRDXstzGVRbwqzve40z6BTDEj4_w@mail.gmail.com>
	<2F5A5082-690F-4C74-A92F-6CC157489B46@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42930 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1KSWWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 17:22:30 -0500
In-Reply-To: <2F5A5082-690F-4C74-A92F-6CC157489B46@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/11/20 Theodore Tso <tytso@mit.edu>:
>
> On Nov 19, 2011, at 10:40 AM, NamJae Jeon wrote:
>
>> Thanks for your opinion.
>> Have you thought that mem spread flags is not needed in group info
>> caches same with page_io and mballoc ?
>
> The group info structures are long lived structures that live a long =
time and will likely be accessed by many NUMA nodes. =C2=A0 So setting =
the men spread flag for the group info cache is more likely to be usefu=
l. =C2=A0 My guess is that any benefit will be extremely hard to measur=
e (especially since the amount of memory used by the group info structu=
res is a pittance compared to the memory used by the inode cache), but =
at least theoretically it would be sound to have that flag set with the=
 group info slab cache.
You're right. I will post the new patch included spread flags about
group info caches again.
Thanks ted.
> Regards,
>
> -- Ted
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
