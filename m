From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] Adding support to freeze and unfreeze a journal
Date: Mon, 9 May 2011 11:24:07 +0200
Message-ID: <20110509092407.GA4122@quack.suse.cz>
References: <AA6B40F6-33A1-4C0B-8F80-71509FFF106E@dilger.ca>
 <1304798662-3884-1-git-send-email-surbhi.palande@canonical.com>
 <4DC65339.7020608@gmail.com>
 <4DC7AE2D.2070602@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
	adilger.kernel@dilger.ca, jack@suse.cz,
	toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DC7AE2D.2070602@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 09-05-11 12:04:45, Surbhi Palande wrote:
> On 05/08/2011 11:24 AM, Marco Stornelli wrote:
> >>+ error = jbd2_journal_flush(journal);
> >>+ if (error>= 0) {
> >>+ write_lock(&journal->j_state_lock);
> >>+ journal->j_flags = journal->j_flags | JBD2_FROZEN;
> >
> >Better journal->j_flags |= JBD2_FROZEN;
> 
> I was wondering why this is actually better than the longer form? Is
> there any technical reason other than preference of coding style
> here?
  It's just a coding style but that's kind of important as well. You don't
have to employ your brain by checking whether the right hand side is the
same as the left hand side in this case. So please use |=.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
