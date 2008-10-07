From: richard kennedy <richard@rsk.demon.co.uk>
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on
   32 bit architecture
Date: Tue, 07 Oct 2008 18:09:06 +0100
Message-ID: <48EB97B2.3010406@rsk.demon.co.uk>
References: <E1KmetO-00053M-5u@closure.thunk.org>	 <20081006232322.c383fac5.akpm@linux-foundation.org> <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756213AbYJGRJb@vger.kernel.org>
In-Reply-To: <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Peter Zijlstra wrote:
....
> +static inline int atomic64_dec_and_test(atomic64_t *v)
> +{
> +	int ret;
> +
> +	write_seqlock(&v->slock);
> +	v->counter--;
> +	ret = !v->counter;
> +	write_sequnlock(&v->slock);
> +
> +	return ret;
> +}
> +
> +static inline int atomic64_add_and_test(atomic64_t *v)
> +{
> +	int ret;
> +
> +	write_seqlock(&v->slock);
> +	v->counter++;
> +	ret = !v->counter;
> +	write_sequnlock(&v->slock);
> +
> +	return ret;
> +}
would it be more logical to call this atomic64_inc_and_test to match the
above dec_and_test ?

regards
Richard
