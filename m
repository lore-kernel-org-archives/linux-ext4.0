From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 Oops (Re: [PATCH V15 06/22] mmc: block: Add blk-mq support)
Date: Thu, 1 Mar 2018 11:07:05 -0500
Message-ID: <20180301160705.GB2490@thunk.org>
References: <1511962879-24262-1-git-send-email-adrian.hunter@intel.com>
 <1511962879-24262-7-git-send-email-adrian.hunter@intel.com>
 <bc65b542-9703-aa04-f1c7-b10584e44391@gmail.com>
 <829308a3-3bf6-c173-65fa-e2a0f45f7f61@intel.com>
 <68886f99-97f5-897a-f754-6f414741bd5a@gmail.com>
 <22580b82-0257-b156-9f0c-79afa34067e5@gmail.com>
 <8876217f-ede6-fc81-2e05-b4fc976b3235@intel.com>
 <6a1267b0-6242-fc9f-60ed-02bf34677b62@intel.com>
 <CAM12Q5TBGwtcMk1pgN70DeqsP7TWtdC4WXhx8jUJe0VekXZJBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Osipenko <digetx@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bough Chen <haibo.chen@nxp.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        Mateusz Nowak <mateusz.nowak@intel.com>,
        Yuliy Izrailov <Yuliy.Izrailov@sandisk.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Dong Aisheng <dongas86@gmail.com>,
        Das Asutosh <asutoshd@codeaurora.org>,
        Zhangfei Gao <zhangfei.gao@gmail.com>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Harjani Ritesh <riteshh@codeaurora.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Linus Walleij <linus.walleij
To: Jose R R <jose.r.r@metztli.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM12Q5TBGwtcMk1pgN70DeqsP7TWtdC4WXhx8jUJe0VekXZJBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 01, 2018 at 01:15:24AM -0800, Jose R R wrote:
> Probably it is not wise to place all your eggs (data) in one basket
> (ext4) and diversify to viable alternatives which won't be affected by
> UNIX 2038 year date problem, likewise?
> < https://metztli.it/blog/index.php/amatl8/reiser-nahui/reiser4-filesystem-and-the-unix
> >

All of the modern file systems (btrfs, ext4, f2fs, xfs, etc.) are fine
with respect to the 2038 problem.

     	   	 				- Ted
