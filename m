From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH] fscrypt: add a documentation file for filesystem-level
 encryption
Date: Mon, 21 Aug 2017 21:44:11 +0800
Message-ID: <9dcef6c6-a758-ea57-0d51-55f33e365931@oracle.com>
References: <20170818194730.61575-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33230 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754279AbdHUNhO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Aug 2017 09:37:14 -0400
In-Reply-To: <20170818194730.61575-1-ebiggers3@gmail.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



> +fscrypt is not guaranteed to protect confidentiality or authenticity
> +if an attacker is able to manipulate the filesystem offline prior to
> +an authorized user later accessing the filesystem.

  How does fscrypt / Android protect against Evil Maid attack. ?

Thanks, Anand
