From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] jbd2: fix printk format warning
Date: Sun, 11 Jan 2009 11:07:13 -0800
Message-ID: <496A4361.5040807@oracle.com>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>	 <20090105121158.94d990c3.randy.dunlap@oracle.com> <1231699973.17759.22.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1231699973.17759.22.camel@odie.local>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Simon Holm Th=F8gersen wrote:
> man, 05 01 2009 kl. 12:11 -0800, skrev Randy Dunlap:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix jbd2 printk format:
>>
>> fs/jbd2/journal.c:848: warning: format '%lu' expects type 'long unsi=
gned int',
>> but argument 3 has type 'uint32_t'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  fs/jbd2/journal.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> --- linux-next-20090105.orig/fs/jbd2/journal.c
>> +++ linux-next-20090105/fs/jbd2/journal.c
>> @@ -845,7 +845,8 @@ static int jbd2_seq_info_show(struct seq
>>  	seq_printf(seq, "  %ums logging transaction\n",
>>  	    jiffies_to_msecs(s->stats->u.run.rs_logging / s->stats->ts_tid=
));
>>  	seq_printf(seq, "  %luus average transaction commit time\n",
>> -		   do_div(s->journal->j_average_commit_time, 1000));
>> +		   (unsigned long)do_div(s->journal->j_average_commit_time,
>> +					1000));
>>  	seq_printf(seq, "  %lu handles per transaction\n",
>>  	    s->stats->u.run.rs_handle_count / s->stats->ts_tid);
>>  	seq_printf(seq, "  %lu blocks per transaction\n",
>=20
> This patch is just as wrong as the original code. Please don't
> apply it, but see my "[PATCH] jbd2: fix wrong use of do_div"
> that I just sent out.

ok, where did you send it?  I don't see it...

--=20
~Randy
