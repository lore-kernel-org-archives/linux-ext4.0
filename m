From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [RFC, PATCH 4/6] jbd: refactor nested journal log recovery loop into separate functions
Date: Sat, 8 Mar 2008 18:40:30 +0000
Message-ID: <e9e943910803081040n78898f20t66a5f8396e63acbe@mail.gmail.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
	 <8644b32ddec999bbc1da0ac55ad7b66d0b8176de.1204685366.git.duaneg@dghda.com>
	 <20080308145351.GB18522@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Tso" <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:22434 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbYCHSkb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Mar 2008 13:40:31 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1064133wff.4
        for <linux-ext4@vger.kernel.org>; Sat, 08 Mar 2008 10:40:31 -0800 (PST)
In-Reply-To: <20080308145351.GB18522@infradead.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/2008, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Mar 06, 2008 at 01:59:12AM +0000, Duane Griffin wrote:
>  > +static int replay_data_block(
>  > +     journal_t *journal, struct buffer_head *obh, char *data,
>  > +     int flags, unsigned long blocknr)
>
> quite odd formatting, this should be more like:
>
>  static int replay_data_block(journal_t *journal, struct buffer_head *obh,
>                 char *data, int flags, unsigned long blocknr)
>
> (same for the other new helpers)

OK, will change.

Thanks,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
