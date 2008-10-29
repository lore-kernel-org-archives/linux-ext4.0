From: Theodore Tso <tytso@mit.edu>
Subject: Re: potential regression in ext[34] call to __page_symlink()?
Date: Wed, 29 Oct 2008 11:40:14 -0400
Message-ID: <20081029154014.GA23643@mit.edu>
References: <170fa0d20810281711s2a508ed2o1af0db30733e8d2d@mail.gmail.com> <20081029024048.GB3766@mit.edu> <20081029032557.GA17624@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kirill Korotaev <dev@openvz.org>
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081029032557.GA17624@wotan.suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 29, 2008 at 04:25:57AM +0100, Nick Piggin wrote:
> 
> I was leaning towards adding a new AOP_FLAG_ there, usable just by
> filesystem code, and just to tell any helper code to clear __GFP_FS.
> That way callers won't get confused into thinking they can do
> GFP_ATOMIC writes from interrupt context or something ;) (which,
> trust me, somebody will attempt to do if it looks remotely feasible!)

Good point!!

						- Ted

