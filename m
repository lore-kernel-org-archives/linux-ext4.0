Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63C4921AD;
	Wed, 13 May 2026 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778695540; cv=none; b=Vn5uATBhlciscNIYWv0Hekhhy3k00zSuLEJ6Jb4VbrPLDH1SMV9kXQIlATa9QsPA1mSdPZlosoVzreGIsRYI+RuzgZr9dtigvaZbfcNEYQXJws9xhlB7aVtrCwZHaevZh/2HTKeEnuMOqB/mZhcMopl0kNzf5dvLxMumY7epg+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778695540; c=relaxed/simple;
	bh=FObxA9O8YlCMGsU3/ZR+niQKY9nN/fot3Xvsd3q5eO4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p3shq++PDhON016EprNNl4la7Wud2LDxoG58ufus9WTWT7D5WM5HkRRB4JgZMQpDFYMCsmk3Uw8ZV6+zUyXHoub8/x8P6IInnSH6pfe6YKgZWLvFEzHFH4PjwKU+ckzxBsFO7o6bJqQpwVg+snJhUQLtMQ+dbdavY9dSFbYqJzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC91B1C04D0;
	Wed, 13 May 2026 17:57:40 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 1D48D6000F;
	Wed, 13 May 2026 17:57:38 +0000 (UTC)
Date: Wed, 13 May 2026 13:57:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Chen <me@linux.beauty>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li
 <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC v7 6/7] ext4: fast commit: add lock_updates tracepoint
Message-ID: <20260513135741.12ddb97d@gandalf.local.home>
In-Reply-To: <20260511084304.1559557-7-me@linux.beauty>
References: <20260511084304.1559557-1-me@linux.beauty>
	<20260511084304.1559557-7-me@linux.beauty>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 1D48D6000F
X-Stat-Signature: 4n9dw11booan7j44n9eumqkhjdm1wa75
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX198duJXJ7wa7OrYOcnAKNIQEiQ8oDaDQ+g=
X-HE-Tag: 1778695058-680248
X-HE-Meta: U2FsdGVkX18Bin5lS/zgG/Cski0L9LniJ7uE3uk964hOlPKW1SqSMAbh7b7ypwRwadFWPkrRs7paoB7tt7AWoJ3fn8EH8JbON+PcO0tWzSUl71fB/qhW83OFS376KUQQd/ruwjuFjki9WnkQmRepV8Qjhue+E3gxkFKtY31tBDOt+bS5Y4/0U5cIzlYGecnuSrM2ikUFvZVb09ihimTa27AESNuazG4CQc6H9TZQW82hBC9LGYFLv6n/1byieBRrd6w2kdOtPo5o/PWS7SNR+NPYkimSfN2JzItsHrkoGihp5bdv+N9/m7B7/fXulFiT

On Mon, 11 May 2026 16:43:01 +0800
Li Chen <me@linux.beauty> wrote:

> @@ -1346,8 +1383,15 @@ static int ext4_fc_perform_commit(journal_t *journal)
>  	}
>  	ext4_fc_unlock(sb, alloc_ctx);
>  
> -	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
> +	ret = ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
> +				      &snap_inodes, &snap_ranges, &snap_err);
>  	jbd2_journal_unlock_updates(journal);
> +	if (trace_ext4_fc_lock_updates_enabled()) {
> +		locked_ns = ktime_to_ns(ktime_sub(ktime_get(), lock_start));
> +		trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns,
> +					   snap_inodes, snap_ranges, ret,
> +					   snap_err);

Please change this to:

		trace_call__ext4_fc_lock_updates(...)

As the "trace_ext4_fc_lock_updates_enabled()" already has the static
branch. No need to do it twice anymore. 7.1 introduced the
"trace_call__foo()" that will do a direct call to the tracepoints
registered, without the need for another static branch.

-- Steve


> +	}
