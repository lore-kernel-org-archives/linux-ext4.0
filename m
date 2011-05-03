From: Jan Kara <jack@suse.cz>
Subject: Re: your mail
Date: Tue, 3 May 2011 15:46:36 +0200
Message-ID: <20110503134636.GA6009@quack.suse.cz>
References: <4DBFE09E.5070805@canonical.com>
 <1304428117-6195-1-git-send-email-surbhi.palande@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Surbhi Palande <surbhi.palande@canonical.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1304428117-6195-1-git-send-email-surbhi.palande@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 03-05-11 16:08:36, Surbhi Palande wrote:
> On munmap() zap_pte_range() is called which dirties the PTE dirty pages as
> Toshiyuki pointed out.
> 
> zap_pte_range()
>   mapping->a_ops->set_page_dirty (= ext4_journalled_set_page_dirty)  
> 
> So, I think that it is here that we should do the checking for a ext4 F.S
> frozen state and also prevent a parallel ext4 F.S freeze from happening.
> 
> Attaching a patch for initial review. Please do let me know your thoughts! 
  This is definitely the wrong place. ->set_page_dirty() callbacks are
called with various locks held and the page need not be locked (thus
dereferencing page->mapping is oopsable). Moreover this particular callback
is called only in data=journal mode.

Believe me, the right place is page_mkwrite() - you have to catch the
read-only => read-write page transition. Once the page is mapped
read-write, you've already lost the race.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
