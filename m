From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: barriers off by default?
Date: Thu, 15 May 2008 19:58:15 -0500
Message-ID: <482CDC27.4090505@redhat.com>
References: <482868A5.1000102@redhat.com> <20080515144355.GB19325@atrey.karlin.mff.cuni.cz> <482CA094.20703@redhat.com> <20080516002145.GA24369@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYEPA6T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 20:58:19 -0400
In-Reply-To: <20080516002145.GA24369@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> On Thu 15-05-08 15:44:04, Eric Sandeen wrote:


>> +	if (!test_opt(sb, BARRIER)) {
>> +		seq_puts(seq, ",barrier=0");
>> +	} else {
>> +		/*
>> +	 	* jbd inherits the barrier flag from ext3, and jbd may actually
>> +	 	* turn off barriers if a write fails, so it's the real test.
>> +	 	*/
>> +		if (journal && !(journal->j_flags & JFS_BARRIER))
>> +			seq_puts(seq, ",barrier=1(failed)");
>> +	}

Actually, since /proc/mounts should substitute for mtab I should not be
putting chatty informational messages in there, should I!

        /*
         * jbd inherits the barrier flag from ext3, and jbd may actually
         * turn off barriers if a write fails, so it's the real test.
         */
        if (!test_opt(sb, BARRIER) ||
            (journal && !(journal->j_flags & JFS_BARRIER)))
                seq_puts(seq, ",barrier=0");

is a better plan.

-Eric
