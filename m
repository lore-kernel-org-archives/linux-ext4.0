From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: don't unconditionally zero blocks on dax writes
Date: Wed, 20 Sep 2017 17:37:07 -0500
Message-ID: <8a714ec4-1584-6aba-a736-605add8fa0ed@redhat.com>
References: <51f1e5a8-0276-5963-afba-b10c6e194b52@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbdITWhI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Sep 2017 18:37:08 -0400
In-Reply-To: <51f1e5a8-0276-5963-afba-b10c6e194b52@redhat.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/20/17 4:44 PM, Eric Sandeen wrote:
> The conversion to iomap seems to have lost the ability to
> conditionally /not/ prezero dax blocks.  This leads to
> double writes which cuts throughput in half in some
> cases.
> 
> This puts back the old conditional zeroing logic.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I might be completely missing something here, i.e. whether
> the change may have been intentional, etc.  The patch is
> only lightly tested but a which check here seems to DTRT.

Whoops, dchinner tells me this is intentional to avoid a data
exposure - sorry if I missed prior conversations about the issue.

Self-NAK on this, I guess.

-Eric
