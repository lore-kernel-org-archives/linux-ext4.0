From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH] ext4: Return EIO on read error in ext4_find_entry
Date: Mon, 26 Jun 2017 12:22:02 -0700
Message-ID: <CAAeU0aOQF=g7zAP5gtOb0ur-zN-crsHTWNbTYJJZvVJa+JoB_w@mail.gmail.com>
References: <20170622232307.48392-1-khazhy@google.com> <20170623044314.7f23ighkelnpgnah@thunk.org>
 <204110E6-EECE-4925-9020-EC6D9633C822@dilger.ca> <20170623122603.jmvyw4oqkojcapv3@thunk.org>
 <C37CE24B-A6E7-4B65-B0C4-4965B3C45007@dilger.ca> <CACGdZYJb4ouFMORaMTM5KubJv_SFpms35fXrTdAK0kxsa7-5Cg@mail.gmail.com>
 <20170623232616.r3ffksjntjfbrzgb@thunk.org> <54BEB476-F6E0-4421-B381-92442457910F@dilger.ca>
 <20170624002454.wjieb3ppvljumzzj@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger@dilger.ca>,
        Khazhismel Kumykov <khazhy@google.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170624002454.wjieb3ppvljumzzj@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 22, 2017 at 4:23 PM, Khazhismel Kumykov <khazhy@google.com> wrote:
> -                       /* read error, skip block & hope for the best */
>                         EXT4_ERROR_INODE(dir, "reading directory lblock %lu",
>                                          (unsigned long) block);
>                         brelse(bh);
> -                       goto next;
> +                       ret = ERR_PTR(-EIO);
> +                       goto cleanup_and_exit;

EXT4_ERROR_INODE() triggers ext4_handle_error() which performs error
handling. I think it should be removed here because we are returning
the error to the caller and there is nothing more drastic about this
error than other error return paths in the same function.
