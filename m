Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED83275B1A
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 06:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010416; cv=none; b=EoovnLzGNPE/Qiwi4eSWl07tXsez+xGdJO24gWjmE7/Rx0S3L8OCWBhsQXfpdB3ITHKbYAOZbvyUFrpgWgOLgGc7Lr6JtgxPJjEq6IWn7a9lc8Cej33BBfYLUtGZYIYgMy/TJKXrnomn/rP6ltXr25gNj6kyALd77VeeI5YbqAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010416; c=relaxed/simple;
	bh=QOlk4/7XmS+Dvvh4zsIn+c758NQjUwIDEuJ6mCb1RhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WqGVZpHLuEDncTo9nI4qnkgeBoQxyeZz07ZgQeylYqJiKqwmO/Ie17wwWsXvGEwKV6S67DSQFt36bqmp5BmQacSkTHn65k6/v2tIMK9NZG9rDWGCZTDKYPZWXMopkAQCxQViRB2rc/q4ftvR39V6+PYlJ7eL4iWcGT02QpvLf7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aPMP8etj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aPMP8etj"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso370969a12.2
        for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 23:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784010415; x=1784615215; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EWLEhkqERYcaPy6Lu/sccZNkhKmKRgHN8QESefuPqFE=;
        b=aPMP8etjYNiopWIan9lE00b4S+ViPJ78K46NPzpWtWAhZkCRQSGNHqN5J+6lpGeNMD
         ieedPaQapP1v58Qnod49jeDe2rVBuuB4XVsY4b4B+LBuoXL43vX6TUOav210uXIVqyQ7
         xqJ2vuDi0mXDwWTP1F1oSndgmkz0wkHS9YRD1omqn7dGeFbpN4DoyAdyXvq1y0XqM5iQ
         0Mppmu9RFcfhWRw3BPxZhh0xOcutuKrjrmgrJ5SblZ1iCFKRClocU5OtIE2/AGiU5Fft
         7Bcbj+nexjbPVpZ/eMSGfz4SLNOBael+98vRCRtr3g4EvL6Ix1+8K5StjOneXK2A5WhO
         ieOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784010415; x=1784615215;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EWLEhkqERYcaPy6Lu/sccZNkhKmKRgHN8QESefuPqFE=;
        b=XkxYjmDXbt6/Q7Cb8I1QvMP21iX/iKcl6gcux8Lmn/Cvmi5LciVvEhHH8+7nLDzWp8
         gvMuWvhLZRgDLASBq8RO9c8X/myg8sQ22TlHi9KWr0+Gnr6qf/dvog3eqVHqu6PqNUit
         z9n0Nf6pCyQvTYtEm6zdmaggHuJG7MIbOBdDNF7b4mQTz54ISfs+cSa8hdoX5JVllLXS
         Og7Y8V9cwavMwWCGoLYmfZq/glqDKTHAdsQW/HyA8tzTw8WQNpTx/rH3myo8XJZNuK8f
         zpMR2laKjCk8BkjUJFfvmYDs71bzWNAiKVEfdSyNt3TSVuBAyl8w8lXAjz+EvSez5PM7
         OysQ==
X-Gm-Message-State: AOJu0YxGXKRg8uuuR0TABeR/Qts1xqQROnU5LA3y7R6DmcS/7zx5wnqC
	Et+a63E2s0oO5kDK1JlF1RpnA5QWEc3K1TczNS1zjawdbokcjwi0/Scc
X-Gm-Gg: AfdE7ckgFFypoOx0UDy2/4XQpi6QnX9Mif1IPU30I6HaMZ2O6iSGYWBMGSdPTrkX/oK
	Gya8grlqNgWN9W/YzTSufqrEM3SVlHN8+29iR1C1FYxsyLpofyXQAC1Mg8tEAA6ETRMtSDeoX1X
	nuqpdzhUvxWqfbfbwSVdImLNhpuWk6fNjN267KsWBFnVSP3AgqFjwN3t6c9fMZBtCzDivoOVUjy
	hyl70tsahKruDVCCe9jwEqMpniLuEYsdrGGI7zilhJrSTKZ8HdL99akgmSdwqCQox6yjDm9Dl8p
	z13Tb/lwjSOeoAMR5ftyifVKdPwCnrguyzYAzeD3HpKl6e9ZAJmDTHlKnDopd50cPXOJna0ZEFt
	GSTZAjiL8hMKM2Rg/eVHxHHHx+gtJTXKQxw62tu4l/ubwzU7jNng4oF8FWjCHWc3tXR5bnmjcgD
	9+BpQ+YJqTD9FGEPqQEO9k1cy60TAINZWI
X-Received: by 2002:a05:6a00:3cc7:b0:845:d274:c01a with SMTP id d2e1a72fcca58-848896eb1e0mr11054809b3a.51.1784010414616;
        Mon, 13 Jul 2026 23:26:54 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f242999sm932902b3a.1.2026.07.13.23.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 23:26:54 -0700 (PDT)
Message-ID: <452a57dd-43ce-4694-9164-8d2512d37417@gmail.com>
Date: Tue, 14 Jul 2026 14:26:11 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] jbd2: check need_resched() when skipping busy
 checkpoint buffers
To: Max Kellermann <max.kellermann@ionos.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 jack@suse.com, stable@vger.kernel.org
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
 <20260713102229.1598812-2-max.kellermann@ionos.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260713102229.1598812-2-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/13/2026 6:22 PM, Max Kellermann wrote:
> journal_shrink_one_cp_list() skips busy checkpoint buffers when called
> with JBD2_SHRINK_BUSY_SKIP.  The continue statement on this path also
> skips the need_resched() check at the end of the loop body.
> 
> Consequently, when a checkpoint list contains mostly busy buffers, the
> shrinker can walk the entire list while holding journal->j_list_lock,
> even when a reschedule has been requested.  Large checkpoint lists under
> memory pressure can therefore cause long lock hold times and leave other
> CPUs spinning on j_list_lock, resulting in soft lockups or RCU stalls.
> 
> Route the busy-buffer path through the need_resched() check so that the
> shrinker can release j_list_lock and reschedule promptly, restoring
> parity with the clean-buffer path, which already checks need_resched().
> This does not change which checkpoint buffers are eligible for removal.
> 
> Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Thanks for the fix! This looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>   fs/jbd2/checkpoint.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 1508e2f54462..5266017565ac 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -389,7 +389,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
>   			ret = jbd2_journal_try_remove_checkpoint(jh);
>   			if (ret < 0) {
>   				if (type == JBD2_SHRINK_BUSY_SKIP)
> -					continue;
> +					goto next;
>   				break;
>   			}
>   		}
> @@ -400,6 +400,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
>   			break;
>   		}
>   
> +next:
>   		if (need_resched())
>   			break;
>   	} while (jh != last_jh);

