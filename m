From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
Subject: Re: [PATCH, v2] ext3: validate directory entry data before use
Date: Sat, 21 Jun 2008 17:13:54 +0100
Message-ID: <ef1cd66f0806210913p59d73cd6he86b656682ad67e9@mail.gmail.com>
References: <1214013261-32428-1-git-send-email-duaneg@dghda.com>
	 <1214063696-16546-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	"Sami Liedes" <sliedes@cc.hut.fi>
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:42352 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYFUQN4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jun 2008 12:13:56 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1372921wfd.4
        for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 09:13:55 -0700 (PDT)
In-Reply-To: <1214063696-16546-1-git-send-email-duaneg@dghda.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Duane,

2008/6/21 Duane Griffin <duaneg@dghda.com>:
> @@ -1397,8 +1434,15 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
>        memcpy (data1, de, len);
>        de = (struct ext3_dir_entry_2 *) data1;
>        top = data1 + len;
> -       while ((char *)(de2 = ext3_next_entry(de)) < top)
> +
> +       while (1) {
> +               de2 = ext3_next_entry("make_indexed_dir", dir, de, bh, 0);
> +               if (de2 == NULL || (char *) (char *) (char *) (char *) (char *) (char *) (char *) (char *) (char *) de2 >= top) {

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This looks very strange!

> +                       break;
> +               }
>                de = de2;
> +       }
> +
>        de->rec_len = ext3_rec_len_to_disk(data1 + blocksize - (char *) de);
>        /* Initialize the root; the dot dirents already exist */
>        de = (struct ext3_dir_entry_2 *) (&root->dotdot);

All the best,
Jochen
-- 
http://seehuhn.de/
