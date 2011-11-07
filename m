From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference from orig_data in fill_super and remount.
Date: Mon, 7 Nov 2011 18:33:14 -0500
Message-ID: <E08B31F5-C43D-4145-BC38-C1C967CDD18E@MIT.EDU>
References: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com> <20111107151939.GA24234@thunk.org> <CAKYAXd_u813Q0k1iMMnfwORxXYDEBtpaKMig1FGBOKpNW3s3rg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@MIT.EDU>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: NamJae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:51208 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab1KGXdR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Nov 2011 18:33:17 -0500
In-Reply-To: <CAKYAXd_u813Q0k1iMMnfwORxXYDEBtpaKMig1FGBOKpNW3s3rg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 7, 2011, at 6:06 PM, NamJae Jeon wrote:

>  if(data) {
>                orig_data = kstrdup(data, GFP_KERNEL);
>                if(!orig_data)
>                        return ret;
>        }

As I said earlier, the use of kstrdup() in the ext4 mount code is so that we can print the mount options used in the mount request.   So if the kstrdup() fails, the worst that will happen is that the printk will print the the mount had no mount options, instead of the mount options which had been passed this might be misleading, but it's not the end of the world; it's only a cosmetic issue.  But if the kstrdup() failed, the other memory allocations (that in general will be for much more memory) will also fail, so the mount will return ENOMEM before ever getting to the printjk.   So a pendant might make the above change, but in practice it's not really that important to do that particular checking in this case.

This is why it's important to really understand the code in question instead of just posting patches without understanding the underlying code, and understanding what might or might not go wrong both before applying the patch, and after applying the patch.   And of course, testing all of the use cases is also really important.

Best regards,

-- Ted

