From: =?UTF-8?B?IkrDs2hhbm4gQi4gR3XDsG11bmRzc29uIg==?=
	<johannbg@gmail.com>
Subject: Re: [PATCH 1/1] ext4: Fix Opts: (null)
Date: Wed, 24 Jul 2013 09:02:04 +0000
Message-ID: <51EF980C.5010203@gmail.com>
References: <1374531868-1800-1-git-send-email-johannbg@fedoraproject.org> <51EF3990.4010901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?B?IkrDsw==?= =?UTF-8?B?aGFubiBCLiBHdcOwbXVuZHNzb24i?=
	<johannbg@fedoraproject.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f46.google.com ([209.85.128.46]:41937 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3GXJEx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jul 2013 05:04:53 -0400
In-Reply-To: <51EF3990.4010901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/24/2013 02:18 AM, Eric Sandeen wrote:
> Have you tested it?  What's the difference in output?

  
-	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
-		 "Opts: %s%s%s", descr, sbi->s_es->s_mount_opts,
+	ext4_msg(sb, KERN_INFO, "mounted filesystem with%s "
+		 "%s%s%s mount option(s)", descr, sbi->s_es->s_mount_opts,
  		 *sbi->s_es->s_mount_opts ? "; " : "", orig_data);


From
mounted filesystem with  Opts: (null)
re-mounted. Opts:(null)

To

mounted filesystem with (null) mount option(s)
re-mounted (null) mount option(s)

That (null) could change to no or none I suppose but it still feels a bit off thou maybe this output sample would be better?

if = (null)

mounted filesystem
re-mounted filesystem

elif

mounted filesystem with x,y.x mount option(s)
re-mounted filesystem with x,y.x mount option(s)

JBG

